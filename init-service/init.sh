#!/bin/bash

debug_log() {
  if [[ "$DEBUG" == "1" ]]; then
    echo "DEBUG: $1"
  fi
}

print_on_start() {
  echo "**********************************************************"
  echo "*                                                        *"
  echo "*  Deploying a Mongo Replica Set to Railway...           *"
  echo "*                                                        *"
  echo "*  To enable verbose logging, set DEBUG=1                *"
  echo "*  and redeploy the service.                             *"
  echo "*                                                        *"
  echo "**********************************************************"
}

check_mongo() {
  local host=$1
  local port=$2
  # Using user/pass environment variables for auth
  mongo_output=$(mongosh --host "$host" --port "$port" --username "$MONGO_INITDB_ROOT_USERNAME" --password "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase "admin" --eval "db.adminCommand('ping')" 2>&1)
  mongo_exit_code=$?
  debug_log "MongoDB check exit code: $mongo_exit_code"
  debug_log "MongoDB check output: $mongo_output"
  return $mongo_exit_code
}

check_all_nodes() {
  local nodes=("$@")
  for node in "${nodes[@]}"; do
    local host=$(echo $node | cut -d: -f1)
    local port=$(echo $node | cut -d: -f2)
    echo "Waiting for MongoDB to be available at $host:$port"
    until check_mongo "$host" "$port"; do
      echo "Waiting..."
      sleep 2
    done
  done
  echo "All MongoDB nodes are up."
}

initiate_replica_set() {
  echo "Initiating replica set."
  
  # NODE1 is considered primary for init purposes
  local primary_host=$(echo $NODE1 | cut -d: -f1) # Assuming standard hostname, but variable might be just hostname
  # Actually the variable passed from railway.json is just the hostname usually, or hostname:port?
  # The reference implies standard ports. Railway private domains are hostnames.
  
  # Constructing the rs.initiate config
  mongosh --host "$NODE1" --port 27017 --username "$MONGO_INITDB_ROOT_USERNAME" --password "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase "admin" <<EOF
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "$NODE1:27017" },
    { _id: 1, host: "$NODE2:27017" },
    { _id: 2, host: "$NODE3:27017" }
  ]
})
EOF
  init_exit_code=$?
  debug_log "Replica set initiation exit code: $init_exit_code"
  return $init_exit_code
}

# Variable array
nodes=("$NODE1:27017" "$NODE2:27017" "$NODE3:27017")

print_on_start
check_all_nodes "${nodes[@]}"

if initiate_replica_set; then
  echo "Replica set initiated successfully."
  exit 0
else
  echo "Failed to initiate replica set."
  exit 1
fi
