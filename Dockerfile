FROM docker.io/oven/bun:latest

# Install Node.js v20
RUN apt-get update && \
  apt-get install -y curl && \
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
  apt-get install -y nodejs && \
  rm -rf /var/lib/apt/lists/*