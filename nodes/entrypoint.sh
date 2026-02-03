#!/bin/bash
set -e

if [ -z "$MONGODB_KEYFILE_CONTENT" ]; then
    echo "ERROR: MONGODB_KEYFILE_CONTENT environment variable is missing."
    exit 1
fi

# Write keyfile to /tmp (often writable in hardened containers)
echo "$MONGODB_KEYFILE_CONTENT" > /tmp/mongo-keyfile
chmod 400 /tmp/mongo-keyfile
chown 999:999 /tmp/mongo-keyfile

# We chain the official docker-entrypoint.sh to handle user creation (via MONGO_INITDB_ROOT_USERNAME/PASSWORD)
# and then start mongod with our custom flags.
#
# Note: The official entrypoint expects the command to be 'mongod' to trigger its init logic.
exec /usr/local/bin/docker-entrypoint.sh mongod --replSet rs0 --keyFile /tmp/mongo-keyfile --bind_ip_all --port 27017
