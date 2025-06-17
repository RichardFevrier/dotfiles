if type -q bat
    function cat
        bat $argv
    end
end
