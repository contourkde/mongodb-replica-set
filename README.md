# MongoDB Replica Set on Railway

This template deploys a specific **MongoDB Replica Set** (PSS Architecture) on [Railway](https://railway.app).

## Architecture

- **Primary**: Handles all write operations.
- **Secondary**: Replicates data from the primary (x2).
- **Init Cluster**: A one-time service that initializes the replica set configuration.

## Pre-requisites

None! The template automatically generates a secure keyfile and root credentials for you.

## Deployment Steps

1. Click the button below to deploy the template.
2. Railway will automatically generate the secrets.
3. The services `mongo-1`, `mongo-2`, and `mongo-3` will start.
4. The `init-cluster` service will wait for them to be ready and then run `rs.initiate()`.

## Connecting

You can connect to your replica set using the Private Networking DNS names provided by Railway, or via the public TCP proxy if you expose them.

The internal connection string format:

```
mongodb://admin:PASSWORD@mongo-1.railway.internal:27017,mongo-2.railway.internal:27017,mongo-3.railway.internal:27017/?replicaSet=rs0&authSource=admin
```

(Replace `PASSWORD` with the generated `MONGO_INITDB_ROOT_PASSWORD` and hostnames with the actual Railway private domains).

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.app/new/template?template=https://github.com/StartYourOwn/mongodb-railway)

> **Note**: Replace `StartYourOwn/mongodb-railway` in the button link above with your actual GitHub repository URL after you push this code.
