server-log-collector
====================

Shell script to collect all files modified between two dates
found recursively in a directory on a remote server.

## LANGUAGE ##

Shell (dash)

## TARGET PLATFORM ##

Ubuntu 12.04 LTS (for both client and server)

## USAGE ##

    # Copy nginx logs from June 2013 to /tmp/nginx-2013-06
    collect-logs.sh \
      --as-sudoer user@hostname \
      --from-directory /var/log/nginx \
      --to-directory /tmp/nginx-2013-06 \
      --from-date 2013-06-01 \
      --to-date 2013-06-30

All parameters are required:

  * `--as-sudoer` - remote user part of sudoers
  * `--from-directory` - absolute path to the logs directory on remote server
  * `--to-directory` - path to the local folder for collected logs,
                       absolute or relative to current folder,
                       which will be created if missing
  * `--from-date` - first modification date for the logs to collect,
                    in ISO format YYYY-MM-DD
  * `--to-date` - last modification date for the logs to collect,
                  in ISO format YYYY-MM-DD

This scripts connects to the remote user with SSH with forwarding of the
authentication agent connection enabled (-A flag), then runs commands using
sudo, based on the assumption that logs are only accessible by admin users.
If you have configured [sudo authentication using SSH agent forwarding, no
password will be requested. Otherwise, you will be prompted for a password.

## AUTHOR ##

Eric Bréchemier <github@eric.brechemier.name>

## LICENSE ##

MIT
