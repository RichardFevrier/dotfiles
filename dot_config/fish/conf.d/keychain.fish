if status is-interactive
    keychain --eval --quiet --noask id_ed25519_(whoami) | source
end
