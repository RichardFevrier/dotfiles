if test -d $HOME/.nodenv
    set -gx NODENV_ROOT $HOME/.nodenv
    fish_add_path -ga $NODENV_ROOT/bin
    if status is-interactive
        nodenv init - | source
        abbr -a nodenv_update "set --local current_dir \$PWD; cd ~/.nodenv/plugins/node-build && git pull --recurse-submodules --jobs=10; cd \$current_dir"
    end
end
