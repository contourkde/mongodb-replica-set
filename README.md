# Simple MongoDB on Railway

This repository deploys a standard, single-node MongoDB instance on Railway.

## Features

- **Persistence**: Uses a Railway Volume mounted at `/data/db` to save data across restarts.
- **Authentication**: configured via `MONGO_INITDB_ROOT_USERNAME` and `MONGO_INITDB_ROOT_PASSWORD`.

## Deployment

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/new?template=https://github.com/contourkde/mongodb-replica-set)

1. Click the button above.
2. Railway will generate a secure `MONGO_INITDB_ROOT_PASSWORD`.
3. Deploy!

## Connecting

Once deployed, you can connect using the `MONGO_URL` provided by Railway (if you add a TCP Proxy) or via the Private Network inside Railway.
