if command -q bat
    function cat
        bat $argv
    end
end
