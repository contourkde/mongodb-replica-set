FROM mongo:8.0

# Expose the default MongoDB port
EXPOSE 27017

# The official image handles the default command (mongod)
# and volume creation (/data/db)
