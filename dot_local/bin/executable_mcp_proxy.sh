#!/bin/sh
# POSIX-compliant wrapper for mcps
# Usage: ./mcp_proxy.sh nginx:latest ...other args...
set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <image> [other options]"
    exit 1
fi

IMAGE_ARG="$1"
shift

PODMAN_ARGS=""
CONTAINER_ARGS=""
found_sep=0
for arg in "$@"; do
    if [ "$arg" = "--" ]; then
        found_sep=1
        continue
    fi
    if [ $found_sep -eq 0 ]; then
        PODMAN_ARGS="$PODMAN_ARGS $arg"
    else
        CONTAINER_ARGS="$CONTAINER_ARGS $arg"
    fi
done

if [ -z "$CONTAINER_ARGS" ]; then
    exec mcp-compressor --toonify -- podman_run_auto_name.sh $IMAGE_ARG -i --rm $PODMAN_ARGS
else
    exec mcp-compressor --toonify -- podman_run_auto_name.sh $IMAGE_ARG -i --rm $PODMAN_ARGS -- $CONTAINER_ARGS
fi
