if status is-interactive
    if command -q chezmoi
        abbr -a cz chezmoi
    end
end
