if status is-interactive
    if command -q eza
        abbr -a lsa "eza -la"
    else
        abbr -a lsa "ls -la"
    end
end
