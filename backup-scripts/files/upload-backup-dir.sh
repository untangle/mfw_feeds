#!/bin/ash

# Constants
TIMEOUT=1200
VERBOSE=false
BACKUP_FILE=mfw_`date -Iseconds`.backup
URL='https://boxbackup.untangle.com/boxbackup/backup.php'

function debug() {
  if [ "true" == $VERBOSE ]; then
    echo $*
  fi
}

function err() {
  echo $* >> /dev/stderr
}

# $1 = tar file
# $2 = dir with backups files
function tarBackupFiles() 
{
    debug "Taring files in $2 into tar $2"
    tar zcfh $1 -C $2 backup_files 
    TAR_EXIT=$?
    debug "Done creating tar with return code $TAR_EXIT"
}

function backupSettings()
{
    # create a tmp directory to store settings
    temp=`mktemp -d -t ut-backup-files.XXXXXXXXXX`
    mkdir -p $temp/etc/config

    # copy settings files to tmp directory
    # only match specific versions without the date/version info so we don't backup old files
    # use -L so symlinks are dereferenced
    cp /etc/config/settings.json $temp/etc/config 
    
    # tar up important files
    tar zcfh $1 -C $temp etc/config 

    # remove tmp dir
    rm -rf $temp
}

# $1 = dir to put backup files
function backupToDir()
{
    outdir=$1

    datestamp=$(date '+%Y%m%d%H%M')

    # create a tarball of settings files
    backupSettings $outdir/backup_files/files-$datestamp.tar.gz

    # save the version of this backup
    cp /etc/os-release $outdir/backup_files
}

function createBackup() {
  debug "Backing up settings to directory"
  DUMP_DIR=`mktemp -d -t ut-backup.XXXXXXXXXX`
  mkdir $DUMP_DIR/backup_files
  backupToDir $DUMP_DIR

  # Tar the contents of the temp directory
  TAR_FILE=`mktemp -t ut-backup.XXXXXXXXXX`
  tarBackupFiles $TAR_FILE $DUMP_DIR

  #debug "Remove dump dir"
  rm -rf $DUMP_DIR

  debug "Gzipping $TAR_FILE"
  gzip $TAR_FILE

  #debug "Copy bundle to $BACKUP_FILE"
  mv $TAR_FILE.gz $BACKUP_FILE
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

####################################
# "Main" logic starts here

while getopts "v" opt; do
  case $opt in
    v) VERBOSE=true;;
  esac
done

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
if [ $CURL_RET -eq 7 ]; then
  # A machine that exists, wrong port (e.g. http://localhost:800/)
  # or machine cannot be contacted then CURL returns 7
  err "CURL returned 7, indicating that the URL $URL could not be contacted"
  rm -f $HEADER_FILE
  exit 4
fi

if [ $CURL_RET -eq 28 ]; then
  # When CURL times out, it returns 28.
  err "CURL returned 28, indicating a timeout when contacting the URL $URL"
  rm -f $HEADER_FILE
  exit 5
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

