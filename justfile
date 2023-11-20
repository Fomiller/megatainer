build-local:
    docker buildx build --platform=linux/arm64 --no-cache --tag=fomiller/megatainer:local .
