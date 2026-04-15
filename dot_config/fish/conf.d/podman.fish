if command -q podman
    if status is-interactive
        abbr -a prmid 'podman rmi (podman images -f "dangling=true" -q) -f 2>/dev/null'
    end
end
