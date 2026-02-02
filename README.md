# MongoDB Replica Set on Railway

This template deploys a specific **MongoDB Replica Set** (PSS Architecture) on [Railway](https://railway.app).

## Architecture

- **Primary**: Handles all write operations.
- **Secondary**: Replicates data from the primary (x2).
- **Init Cluster**: A one-time service that initializes the replica set configuration.

## Pre-requisites

You need to generate a Base64 encoded keyfile content to secure the inter-node communication.

Run this locally to generate a valid string:

```bash
openssl rand -base64 756 | tr -d '\n'; echo
```

Copy the output string. You will need it for the `MONGODB_KEYFILE_CONTENT` variable.

## Deployment Steps

1. Deploy this template.
2. Railway will ask for the `MONGODB_KEYFILE_CONTENT` variable. Paste the string you generated above.
3. The services `mongo-1`, `mongo-2`, and `mongo-3` will start.
4. The `init-cluster` service will wait for them to be ready and then run `rs.initiate()`.
5. Once `init-cluster` completes successfully, your replica set is ready!

## Connecting

You can connect to your replica set using the Private Networking DNS names provided by Railway, or via the public TCP proxy if you expose them.

The connection string format for internal use:

```
mongodb://mongo-1.railway.internal:27017,mongo-2.railway.internal:27017,mongo-3.railway.internal:27017/?replicaSet=rs0
```

(Note: Replace hostnames with the actual Railway private domains if they differ).
