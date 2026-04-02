#!/bin/sh
# POSIX-compliant wrapper for podman to simulate "nginx, nginx_1..." naming
# Usage: ./podman_run_auto_name.sh nginx:latest ...other args...
set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <image> [other options]"
    exit 1
fi

IMAGE_ARG="$1"
shift

# Extract base name from image (e.g. "nginx:latest" -> "nginx", "registry/nginx:latest" -> "nginx")
if echo "$IMAGE_ARG" | grep -q ':'; then
    BASE_NAME=$(echo "$IMAGE_ARG" | sed 's/:.*//' | sed 's|.*/||')
else
    BASE_NAME=$(echo "$IMAGE_ARG" | sed 's|.*/||')
fi

# Sanitize: keep only alphanumeric, hyphens and underscores to avoid grep regex injection
BASE_NAME=$(echo "$BASE_NAME" | tr -cd 'A-Za-z0-9_-')

if [ -z "$BASE_NAME" ]; then
    echo "Error: could not derive a valid container name from image '$IMAGE_ARG'" >&2
    exit 1
fi

# Check whether a given name is already in use (exact match)
check_name() {
    podman ps -a --format "{{.Names}}" | grep -qx "$1"
}

# 1. Try the base name first (e.g. "nginx")
if ! check_name "$BASE_NAME"; then
    FINAL_NAME="$BASE_NAME"
else
    # 2. Try incrementing suffixes: "nginx_1", "nginx_2", ...
    COUNTER=1
    FINAL_NAME=""
    while [ -z "$FINAL_NAME" ]; do
        CANDIDATE="${BASE_NAME}_${COUNTER}"
        if ! check_name "$CANDIDATE"; then
            FINAL_NAME="$CANDIDATE"
        fi
        COUNTER=$((COUNTER + 1))
    done
fi

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
    exec podman run $PODMAN_ARGS --name "$FINAL_NAME" "$IMAGE_ARG"
else
    exec podman run $PODMAN_ARGS --name "$FINAL_NAME" "$IMAGE_ARG" $CONTAINER_ARGS
fi
