if status is-interactive
    if type -q eza
        abbr -a lsa "eza -la"
    else
        abbr -a lsa "ls -la"
    end
end
