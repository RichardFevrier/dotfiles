if test -d $HOME/.rbenv
    set -gx RBENV_ROOT $HOME/.rbenv
    fish_add_path -ga $RBENV_ROOT/bin
    if status is-interactive
        rbenv init - | source
        abbr -a rbenv_update "set --local current_dir \$PWD; cd ~/.rbenv && git pull --recurse-submodules --jobs=10; cd \$current_dir"
    end
end
