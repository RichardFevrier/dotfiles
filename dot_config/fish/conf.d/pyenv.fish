if test -d $HOME/.pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path -ga $PYENV_ROOT/bin
    if status is-interactive
        pyenv init - | source
        abbr -a pyenv_update "set --local current_dir \$PWD; cd ~/.pyenv && git pull --recurse-submodules --jobs=10; cd \$current_dir"
    end
end
