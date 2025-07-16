if status is-interactive
    if command -q vivid
        set -gx LS_COLORS $(vivid generate bogster)
    end
end
