#!/bin/bash
set -e

if [ -z "$MONGODB_KEYFILE_CONTENT" ]; then
    echo "ERROR: MONGODB_KEYFILE_CONTENT environment variable is missing."
    exit 1
fi

# Write keyfile (must be exactly 400 permissions for Mongo to start)
# We use /tmp because on some restricted environments we might not have write access to /etc
echo "$MONGODB_KEYFILE_CONTENT" > /tmp/mongo-keyfile
chmod 400 /tmp/mongo-keyfile

# Start mongod with the required flags
# - replSet: Defines the replica set name
# - keyFile: Path to the internal auth key
# - bind_ip_all: Listen on all interfaces
# - port: Explicitly listen on 27017
exec mongod --replSet rs0 --keyFile /tmp/mongo-keyfile --bind_ip_all --port 27017
