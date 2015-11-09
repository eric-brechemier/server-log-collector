#! /bin/sh
#
# Collect log files corresponding to an interval of time from a server
# https://github.com/eric-brechemier/server-log-collector
#
# Usage:
#  # Copy nginx logs from June 2013 to /tmp/nginx-2013-06
#  collect-logs.sh \
#    --as-sudoer user@hostname \
#    --from-directory /var/log/nginx \
#    --to-directory /tmp/nginx-2013-06 \
#    --from-date 2013-06-01 \
#    --to-date 2013-06-30
#
# Parameters: (all parameters are required)
#
# * --as-sudoer - remote user part of sudoers
# * --from-directory - absolute path to the logs directory on remote server
# * --to-directory - output folder for collected logs,
#                     absolute or relative to current folder,
#                     which will be created if missing
# * --from-date - first modification date for the logs to collect,
#                  in ISO format YYYY-MM-DD
# * --to-date - last modification date for the logs to collect,
#                 in ISO format YYYY-MM-DD

set -eu

usage="Usage:
# Copy nginx logs from June 2013 to /tmp/nginx-2013-06
collect-logs.sh \\
--as-sudoer user@hostname \\
--from-directory /var/log/nginx \\
--to-directory /tmp/nginx-2013-06 \\
--from-date 2013-06-01 \\
--to-date 2013-06-30"

asSudoer=''
fromDirectory=''
toDirectory=''
fromDate=''
toDate=''

# parse arguments
while test $# -gt 0
do
  case "$1" in
    --as-sudoer)
      asSudoer="$2"
      shift
    ;;
    --from-directory)
      fromDirectory="$2"
      shift
    ;;
    --to-directory)
      toDirectory="$2"
      shift
    ;;
    --from-date)
      fromDate="$2"
      shift
    ;;
    --to-date)
      toDate="$2"
      shift
    ;;
    *)
      echo "$usage"
      echo "Unsupported parameter: $1"
      exit 1
  esac
  shift
done

if test -z "asSudoer" \
     -o -z "$fromDirectory" \
     -o -z "$toDirectory" \
     -o -z "$fromDate" \
     -o -z "$toDate"
then
  echo "$usage"
  echo "All parameters are mandatory."
  exit 1
fi

fromDateInt=$(printf %b "$fromDate" | tr -d '-')
toDateInt=$(printf %b "$toDate" | tr -d '-')

echo "Change to directory $toDirectory"
mkdir -p "$toDirectory"
cd "$toDirectory"

echo "Select logs from $fromDate to $toDate as $asSudoer"
remoteArchive=$(
  cat << EOF | ssh -A -T "$asSudoer" | tail -n 1
  cd "$fromDirectory" &&
  remoteArchive=\$(mktemp --suffix=.tar.gz) &&
  sudo find . -type f -printf "%TY%Tm%Td %p\n" |
  while read -r fileDateInt fileName
  do
    if test "$fromDateInt" -le "\$fileDateInt" \
         -a "\$fileDateInt" -le "$toDateInt"
    then
      echo "\$fileName"
    fi
  done |
  xargs sudo tar czf "\$remoteArchive" &&
  echo "\$remoteArchive" || echo "FAILED"
EOF
)

if test "FAILED" = "$remoteArchive"
then
  echo "Failed to save logs in remote archive"
  exit 1
fi

localArchive=$(mktemp --suffix=.tar.gz)
echo "Copy remote archive $asSudoer:$remoteArchive to local archive $localArchive"
scp "$asSudoer:$remoteArchive" "$localArchive"

echo "Extract logs from temporary archive $localArchive"
tar xf "$localArchive"

echo "Delete local archive $localArchive"
rm -f "$localArchive"

echo "Delete remote archive $asSudoer:$remoteArchive"
ssh -A "$asSudoer" "sudo rm $remoteArchive"

echo "Complete: logs extracted to $toDirectory"
