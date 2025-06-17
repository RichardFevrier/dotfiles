if status is-interactive
    if type -q vivid
        set -gx LS_COLORS $(vivid generate bogster)
    end
end
