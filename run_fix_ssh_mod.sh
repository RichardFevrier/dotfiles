#!/bin/sh

SSH_DIR="${1:-$HOME/.ssh}"

if [ ! -d "$SSH_DIR" ]; then
    echo "Directory '$SSH_DIR' not found."
    exit 1
fi

echo "Fixing SSH permissions in: $SSH_DIR"

chmod 700 "$SSH_DIR"
echo "  [700] $SSH_DIR"

for f in "$SSH_DIR"/*; do
    [ -f "$f" ] || continue
    base=$(basename "$f")

    case "$base" in
        authorized_keys|config|environment)
            chmod 400 "$f"
            echo "  [400] $f"
            ;;
        known_hosts|known_hosts.*)
            chmod 600 "$f"
            echo "  [600] $f"
            ;;
        *.pub)
            chmod 444 "$f"
            echo "  [444] $f"
            ;;
        *)
            chmod 400 "$f"
            echo "  [400] $f"
            ;;
    esac
done

echo "Done."
