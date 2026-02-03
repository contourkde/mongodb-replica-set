# Base image (User requested preservation of UBI image)
FROM mongodb/mongodb-community-server:8.0-ubi9

# Switch to root to install/copy files
USER root

# Copy the keyfile generation script
COPY generate-keyfile.sh /generate-keyfile.sh
RUN chmod +x /generate-keyfile.sh

# Switch back to the standard user (using numeric ID 999 for safety)
USER 999

# Entrypoint: Generate keyfile then run standard entrypoint
# We use full path /usr/local/bin/docker-entrypoint.sh because it might not be in PATH for sh -c
ENTRYPOINT ["/bin/bash", "-c", "/generate-keyfile.sh && exec /usr/local/bin/docker-entrypoint.sh mongod --replSet rs0 --auth --keyFile /data/keyfile --bind_ip_all"]
