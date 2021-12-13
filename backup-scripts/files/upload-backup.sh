#!/bin/ash

. /usr/share/libubox/jshn.sh

# Constants
TIMEOUT=1200
VERBOSE=false
BACKUP_FILE=mfw_`date -Iseconds`.backup.gz
URL='https://boxbackup.untangle.com/boxbackup/backup.php'


function debug() {
  if [ "true" == $VERBOSE ]; then
    echo $*
  fi
}

function err() {
  echo $* >> /dev/stderr
}

function createBackup() {
  debug "Backing up settings to gunzip file"
  TEMP_DIR=`mktemp -d -t ut-backup.XXXXXXX`

  cp /etc/config/settings.json $TEMP_DIR
  gzip $TEMP_DIR/settings.json
  mv $TEMP_DIR/settings.json.gz ./$BACKUP_FILE   

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
  debug "Calling CURL.  Dumping headers to $2"
  md5=`md5sum $1 | awk '{ print $1 }'`
  debug "Backup file MD5: $md5"
  debug "curl $URL -k -F uid=$UID -F uploadedfile=@$1 -F md5=$md5 --dump-header $2 --max-time $TIMEOUT"
  curl "$URL" -k -F uid="$UID" -F uploadedfile=@$1 -F md5="$md5" --dump-header $2 --max-time $TIMEOUT > /dev/null 2>&1
  return $?
}

function checkLicense() {
  json_init
  json_load_file /etc/config/licenses.json
  if json_is_a list array
  then
    json_select list
    idx=1

    while json_is_a $idx object 
    do
      json_select $idx
      json_get_var licenseName name 
      debug "License found for: " $licenseName

      json_select ..
      idx=$(( idx + 1 ))
    done

    idx=$(( idx - 1 ))
    debug "Total licenses: $idx"
  else 
    debug "Invalid license json array, not backing up"
    exit 1   
  fi
  
  if [ "$idx" -eq 0 ]; then
    debug "No licenses, not completing back up"
    exit 0
  fi 

  debug "Licenses found, completing backup"
}

####################################
# "Main" logic starts here

while getopts "v" opt; do
  case $opt in
    v) VERBOSE=true;;
  esac
done

# determine if license correct
checkLicense

# get uid
UID=`cat /etc/config/uid`

# create backup file
createBackup

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

