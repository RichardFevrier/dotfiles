if command -q yazi
    function y
        set --local tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file=$tmp
        set --local cwd (cat $tmp)
        builtin cd $cwd
        rm -f $tmp
    end
    if status is-interactive
        abbr -a yazi_update "ya pkg upgrade"
    end
end
