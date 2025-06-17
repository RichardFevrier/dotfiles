if type -q yazi
    function y
        set --local tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file=$tmp
        set --local cwd (cat $tmp)
        builtin cd $cwd
        rm -f $tmp
    end
end

if status is-interactive
    if type -q yazi
        abbr -a yazi_update "ya pkg upgrade"
    end
end
