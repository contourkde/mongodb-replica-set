FROM mongodb/mongodb-community-server:8.0-ubi9

COPY init.sh /init.sh
USER root
RUN chmod +x /init.sh
USER mongodb

ENTRYPOINT ["/init.sh"]
