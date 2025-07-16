if status is-interactive
    if command -q app
        function app_brew_diff
            app_diff ~/.config/app/packages/brew.json "brew leaves"
        end

        function app_flatpak_diff
            app_diff ~/.config/app/packages/flatpak.json "flatpak list --app --columns=application"
        end

        function app_diff --argument-names json_path system_cmd
            set --local app_output (string split ' ' (string match -r '"packages": "(.*?)"' (cat $json_path))[2])
            set --local system_output (eval $system_cmd)

            for app in $app_output
                if not contains -- $app $system_output
                    echo "Missing from system: $app"
                end
            end

            for app in $system_output
                if not contains -- $app $app_output
                    echo "Not listed in file: $app"
                end
            end
        end
    end
end
