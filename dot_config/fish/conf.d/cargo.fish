if test -d $HOME/.cargo
    set -gx CARGO_ROOT $HOME/.cargo
    fish_add_path -ga $CARGO_ROOT/bin
end
