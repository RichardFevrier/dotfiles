if status is-interactive

    bind \cc 'yank'
    bind \ck 'cancel-commandline'
    stty intr ^K
    # stty lnext ^N


    abbr -a cl clear

    abbr -a rmf "rm -Rf"

    fish_config theme choose Bogster

    function fish_greeting
        # if type -q macchina
        #     macchina
        # end
    end
end
