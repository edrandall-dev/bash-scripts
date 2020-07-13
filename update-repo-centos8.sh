#!/bin/bash

#
# Set some variables
#
MIRROR="anorien.csc.warwick.ac.uk"
LOCAL_REPO_DIR="/mnt/raid2/centos"

#
# Check there's no rsync jobs already running
#
if [ -f /var/lock/subsys/rsync_updates ]; then
    echo "Updates via rsync already running."
    exit 1
fi

#
# Handle missing target directories
#
[ ! -d "$LOCAL_REPO_DIR" ] && { echo "ERROR: $LOCAL_REPO_DIR doesn't exist" ; exit 1; };
[ ! -d "$LOCAL_REPO_DIR/8" ] && { mkdir "$LOCAL_REPO_DIR/8"; };

#
# Create the lockfile
#
touch /var/lock/subsys/rsync_updates

#
# Download GPG Keys
#
cd $LOCAL_REPO_DIR
wget -q http://anorien.csc.warwick.ac.uk/CentOS/RPM-GPG-KEY-CentOS-Official

#
# Sync CentOS 8
#
cd $LOCAL_REPO_DIR/8
rsync  -avSHP --delete --exclude "isos"  rsync://$MIRROR/CentOS/8/ "$LOCAL_REPO_DIR/8/"

#
# Remove the lockfile
#
rm -f /var/lock/subsys/rsync_updates

exit 0
