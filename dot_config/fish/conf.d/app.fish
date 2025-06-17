if status is-interactive
    if type -q app
        abbr -a app_brew_diff "set --local app_output (cat ~/.config/app/packages/brew.json); for i in (brew leaves); if not string match -rq \$i \$app_output; echo \$i; end; end"
    end
end
