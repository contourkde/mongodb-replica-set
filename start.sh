#!/bin/bash

# Wrapper script to make the root deployment act as the init-service
# This allows Railway to find a start command when building from the root.

echo ">>> Wrapper: Starting init-service logic from root start.sh"
echo ">>> Wrapper: Current Directory: $(pwd)"

# Check if we have execution permissions
if [ ! -x "./initService/initiate-replica-set.sh" ]; then
    echo ">>> Wrapper: Fixing permissions for initiate-replica-set.sh"
    chmod +x ./initService/initiate-replica-set.sh
fi

echo ">>> Wrapper: Executing initService/initiate-replica-set.sh"
./initService/initiate-replica-set.sh
