#!/bin/bash
set -e

echo "Starting replica set initialization..."

# Check if environment variables are set
if [ -z "$NODE1" ] || [ -z "$NODE2" ] || [ -z "$NODE3" ]; then
  echo "Error: NODE1, NODE2, and NODE3 environment variables must be set."
  exit 1
fi

if [ -z "$MONGO_INITDB_ROOT_USERNAME" ] || [ -z "$MONGO_INITDB_ROOT_PASSWORD" ]; then
  echo "Error: Root credentials must be set."
  exit 1
fi

echo "Nodes to configure:"
echo "Node 1: $NODE1"
echo "Node 2: $NODE2"
echo "Node 3: $NODE3"

# Helper function to wait for a host to be reachable
wait_for_host() {
  local host="$1"
  local port=27017
  echo "Waiting for $host:$port..."
  # We use the credentials to ping, as auth requires it
  until mongosh --host "$host" --port "$port" -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin --eval "quit()" &>/dev/null; do
    echo "  $host unreachable or auth failed, retrying in 2 seconds..."
    sleep 2
  done
  echo "  $host is UP!"
}

# Wait for all nodes to be ready
wait_for_host "$NODE1"
wait_for_host "$NODE2"
wait_for_host "$NODE3"

echo "All nodes are up. Initiating replica set..."

# Initiate the replica set
# We connect to NODE1 to run the initiate command
mongosh --host "$NODE1" --port 27017 -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin <<EOF
var config = {
    "_id": "rs0",
    "members": [
        { "_id": 0, "host": "$NODE1:27017" },
        { "_id": 1, "host": "$NODE2:27017" },
        { "_id": 2, "host": "$NODE3:27017" }
    ]
};
try {
    var status = rs.status();
    if (status.ok === 1 && status.set === "rs0") {
         print("Replica set is already initialized.");
         quit(0);
    }
    
    rs.initiate(config);
    print("Replica set initiated successfully!");
} catch (e) {
    print("Error initiating replica set: " + e);
    if (e.codeName === 'AlreadyInitialized') {
        print("Replica set was already initialized (caught exception).");
    } else {
        quit(1);
    }
}
EOF

echo "Initialization script completed."
