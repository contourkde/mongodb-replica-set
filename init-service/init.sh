#!/bin/bash
set -e

echo "Starting replica set initialization..."

# Check if environment variables are set
if [ -z "$NODE1" ] || [ -z "$NODE2" ] || [ -z "$NODE3" ]; then
  echo "Error: NODE1, NODE2, and NODE3 environment variables must be set."
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
  until mongosh --host "$host" --port "$port" --eval "quit()" &>/dev/null; do
    echo "  $host unreachable, retrying in 2 seconds..."
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
mongosh --host "$NODE1" --port 27017 <<EOF
var config = {
    "_id": "rs0",
    "members": [
        { "_id": 0, "host": "$NODE1:27017" },
        { "_id": 1, "host": "$NODE2:27017" },
        { "_id": 2, "host": "$NODE3:27017" }
    ]
};
try {
    rs.initiate(config);
    print("Repica set initiated successfully!");
} catch (e) {
    print("Error initiating replica set: " + e);
    // If it's already initialized, this might fail, which is fine for idempotency
    if (e.codeName === 'AlreadyInitialized') {
        print("Replica set was already initialized.");
    } else {
        quit(1);
    }
}
EOF

echo "Initialization script completed."
