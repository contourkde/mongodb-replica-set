FROM mongodb/mongodb-community-server:8.0-ubi9

COPY init.sh /init.sh
USER root
RUN chmod +x /init.sh

# Use numeric ID 999 (standard for mongodb in official images) to avoid "user not found" build errors
USER 999

ENTRYPOINT ["/init.sh"]
