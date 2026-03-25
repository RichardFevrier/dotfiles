if test -d $HOME/.cargo; or command -q cargo
    set -gx CARGO_HOME $HOME/.cargo
    fish_add_path -ga $CARGO_HOME/bin
end
