# Base image (User requested preservation of UBI image)
FROM mongodb/mongodb-community-server:8.0-ubi9

# Switch to root to copy script
USER root

# Copy the initiation script
COPY --chmod=755 init.sh /init.sh

# Switch to standard user
USER 999

# Set the entrypoint
ENTRYPOINT ["/bin/bash", "/init.sh"]
