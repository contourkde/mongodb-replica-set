# Dockerfile (repo root)
FROM alpine:3.19
CMD ["sh", "-c", "echo 'Root service is a placeholder. All real services are defined in railway.json.' && sleep infinity"]
