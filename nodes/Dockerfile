FROM mongodb/mongodb-community-server:8.0-ubi9

USER root
# Ensure scripts are executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# MongoDB healthcheck best practice
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s --retries=3 \
    CMD mongosh --eval "db.adminCommand('ping')" || exit 1

USER mongodb
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
