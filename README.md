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
  * `--to-directory` - output folder for collected logs,
                       absolute or relative to current folder,
                       which will be created if missing
  * `--from-date` - first modification date for the logs to collect,
                    in ISO format YYYY-MM-DD
  * `--to-date` - last modification date for the logs to collect,
                  in ISO format YYYY-MM-DD

This script connects to the remote user using SSH with forwarding of the
authentication agent connection enabled (-A flag), then runs commands using
sudo, based on the assumption that logs are only accessible by admin users.
If you have configured [sudo authentication using SSH agent forwarding]
(http://www.evans.io/posts/ssh-agent-for-sudo-authentication/), no password
will be requested.

The log files are selected on the server, packed as a tar.gz archive
in a temporary location on the server, then copied back to the local system
using `scp` and expanded into the target directory. Temporary archives used
for the transfer are then deleted.

## AUTHOR ##

Eric Bréchemier <github@eric.brechemier.name>

## LICENSE ##

MIT
