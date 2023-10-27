#!/bin/ash

. /usr/share/libubox/jshn.sh

# Constants
TIMEOUT=1200
VERBOSE=false
SEND_CURL=true
BACKUP_COPY_DIR=""
BACKUP_FILE=mfw_`date -Iseconds`.backup.tar.gz
URL='https://boxbackup.untangle.com/boxbackup/backup.php'
TRANSLATED_URL=$(wget -qO- "http://127.0.0.1/api/uri/geturiwithpath/uri=$URL")
if [ "$TRANSLATED_URL" != "" ] ; then
    URL=$TRANSLATED_URL
fi

# Debug function
function debug() {
  if [ "true" == $VERBOSE ]; then
    echo $*
  fi
}

# Error function
function err() {
  echo $* >> /dev/stderr
}

# Create backup coping settings file to a temp dir
function createBackup() {
  debug "Backing up settings to gunzipped tar archive file"
  TEMP_DIR=`mktemp -d -t ut-backup.XXXXXXX`
  TEMP_DIR_NAME=$(basename $TEMP_DIR)

  cp /etc/config/settings.json $TEMP_DIR
  rsync -av --exclude /captive_portal/captive_portal_settings /etc/config/captive_portal $TEMP_DIR
  tar -C /tmp -zcf $BACKUP_FILE $TEMP_DIR_NAME
  rm -r $TEMP_DIR
}

# Gets the HTTP status code from the output of CURL.  Note
# that for odd reasons (not sure why) there is often a "100"
# (is that "continue?) then a "404", so we choose the *last*
# response code as the status.
function getHTTPStatus() {
  cat ${1} | sed -n "/HTTP\/1.1/ p" | awk '{ print $2; }' | tail -1
}


# 1 = name of backup file
# 2 = name of file to write response headers
#
# returns the return of CURL
function callCurl() {
  # read MFW version from /etc/os-release
  full_mfw_version=$(grep 'VERSION=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
  version_string="${full_mfw_version#*v}"     # Remove the leading 'v'
  mfw_version="${version_string%%-*}"         # Remove everything after the first '-'
  debug "MFW version detected: $mfw_version"

  debug "Calling CURL.  Dumping headers to $2"
  md5=`md5sum $1 | awk '{ print $1 }'`
  debug "Backup file MD5: $md5"
  debug "curl $URL -k -F uid=$UID -F uploadedfile=@$1 -F md5=$md5 -F version=$mfw_version --dump-header $2 --max-time $TIMEOUT"
  curl "$URL" -k -F uid="$UID" -F uploadedfile=@$1 -F md5="$md5" -F version="$mfw_version" --dump-header $2 --max-time $TIMEOUT > /dev/null 2>&1
  return $?
}

# Check has any licenses. IF has any licenses, can run autobackup. 
function checkLicense() {
  # Load file
  json_init
  json_load_file /etc/config/licenses.json

  # if is an array, then continue
  if json_is_a list array
  then
    json_select "list"
    local idx=1

    # keep track of number of licenses 
    while json_is_a $idx object 
    do
      json_select "$idx"
      json_get_var licenseName name 
      debug "License found for: " $licenseName

      json_select ".."
      idx=$(( idx + 1 ))
    done

    idx=$(( idx - 1 ))
    debug "Total licenses: $idx"
  else 
    debug "Invalid license json array, not backing up"
    exit 1   
  fi

  # if total is 0, then no licenses found  
  if [ "$idx" -eq 0 ]; then
    debug "No licenses, not completing back up"
    exit 0
  fi 

  debug "Licenses found, completing backup"
}

# check if autobackup is enabled
function checkEnable() {
  json_init
  json_load_file /etc/config/settings.json

  json_select system
  if json_get_type Type autoBackup && [ "$Type" == object ] 
  then
    json_select autoBackup
    json_get_var enabled enabled
    
    if [ "$enabled" -eq 0 ]; then
      debug "Auto backup not enabled"
      exit 0 
    fi
  else
    debug "Couldn't find enable status"
    exit 1
  fi
}

# cleanup - called on exit
function cleanup() {
  # removing the backup file.
  debug "Remove backup file $BACKUP_FILE"
  rm -f $BACKUP_FILE
}

####################################
# "Main" logic starts here

trap cleanup EXIT

while getopts "vc:" opt; do
  case $opt in
    v) VERBOSE=true;;
    # Takes a directory to copy the backup file to for future retrieval.
    # Does NOT send the curl command containing the file to CMD
    c)
     SEND_CURL=false
     BACKUP_COPY_DIR=$OPTARG
     if ! [ -w $BACKUP_COPY_DIR ]; then 
      echo "Can't write backup to provided directory ${BACKUP_COPY_DIR}"
      exit 1
     fi
     ;;
  esac
done

# determine if enabled
checkEnable

# determine if license correct. Only check the licesne if sending the backup
# to the cloud for storage with the curl command
if $SEND_CURL; then
  checkLicense
fi

# get uid
UID=`cat /etc/config/uid`

# create backup file
createBackup

# In the case where a backup file needs to be created and 
# grabbed by MFW to send to the front end, just tell MFW
# where the file is and exit
if ! $SEND_CURL; then

  # Copy the backup file to the /tmp directory for 
  # retrieval by MFW. The original will get deleted
  cp $BACKUP_FILE $BACKUP_COPY_DIR

  echo "Backup location: ${BACKUP_COPY_DIR}/${BACKUP_FILE}"
  
  # return here to avoid the file being deleted 
  # Let MFW grab it and delete it
  exit 0
fi

debug "Running backup"
debug "URL: " $URL
debug "UID: " $UID
debug "File: " $BACKUP_FILE

HEADER_FILE=`mktemp -t ut-remotebackup.XXXXXXXXXX`
callCurl $BACKUP_FILE $HEADER_FILE
CURL_RET=$?
debug "CURL returned $CURL_RET"

# Check CURL return codes
if [ $CURL_RET -ne 0 ]; then
  # A machine that exists, wrong port (e.g. http://localhost:800/)
  # or machine cannot be contacted then CURL returns 7
  #
  # When CURL times out, it returns 28.
  #
  # when CURL errors out, response is non zero 
  err "CURL returned $CURL_RET"
  rm -f $HEADER_FILE
  exit 2
fi

# Get the HTTP status code from the CURL header file
RETURN_CODE=`getHTTPStatus $HEADER_FILE`
debug "HTTP status code $RETURN_CODE"

# Remove the header file
debug "Remove header file $HEADER_FILE"
rm -f $HEADER_FILE

if [ ! -z "$RETURN_CODE" ] ; then
    # Evaluate HTTP status code
    if [ $RETURN_CODE -eq 401 ];then
        err "Remote server at URL $URL returned 401"
        exit 3
    fi
    if [ $RETURN_CODE -eq 403 ];then
        err "Remote server at URL $URL returned 403"
        exit 3
    fi
fi

if [ $RETURN_CODE -gt 200 ]
then
  # Web server exists, "page" not found.  CURL returns 0
  # and we parse for the 404.  This would be for a bad URL which
  # happened to point at a real web server
  err "Remote server at URL $URL returned $RETURN_CODE which is too high.  Assume failure"
  exit 2
else
  debug "Backup to remote URL complete"
  exit 0
fi

