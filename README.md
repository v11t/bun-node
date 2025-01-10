# Bun + Node.js Docker Image Builder

Cross-platform Docker image that combines Bun and Node.js runtimes. Supports linux/amd64 and linux/arm64 architectures.

## Prerequisites

- Docker with buildx support
- Docker registry access

## Usage

```bash
./build.sh
```

The script will:

1. Create a multi-arch image using Docker buildx
2. Install Node.js 20.x alongside Bun
3. Push the image to the registry as `v11t/bun-node:{BUN_VERSION}-{NODE_VERSION}`

## Image Details

- Base Image: `public.ecr.aws/coloop/oven/bun`
- Added Components: Node.js 20.x
- Architectures: linux/amd64, linux/arm64
- Tag Format: `{BUN_VERSION}-{NODE_VERSION}` (e.g., `1.0.0-20.0.0`)

## Development

To modify the build:

1. Edit `Dockerfile` generation in `build.sh`
2. Add additional build steps or dependencies
3. Adjust platform targets in `PLATFORMS` variable

## License

MIT
