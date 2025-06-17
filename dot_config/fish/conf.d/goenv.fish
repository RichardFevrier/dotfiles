if test -d $HOME/.goenv
    set -gx GOENV_ROOT $HOME/.goenv
    fish_add_path -ga $GOENV_ROOT/bin
    if status is-interactive
        goenv init - | source
        fish_add_path -ga $GOROOT/bin
        fish_add_path -ga $GOPATH/bin
        abbr -a goenv_update "set --local current_dir \$PWD; cd ~/.goenv && git pull --recurse-submodules --jobs=10; cd \$current_dir"
    end
end
