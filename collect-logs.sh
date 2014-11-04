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

# Work In Progress
