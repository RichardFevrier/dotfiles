if test -d $HOME/.go; or command -q go
    set -gx GOPATH $HOME/.go
    fish_add_path -ga $GOPATH/bin
end
