if status is-interactive
    if command -q odin
        abbr -a odin_update "set --local current_dir \$PWD; set --local odin_update_output (cd $(dirname $(realpath $(which odin))) && git pull --recurse-submodules --jobs=10); if not string match -r \"Already up to date\" \$odin_update_output; make release-native; end; cd \$current_dir"
    end
    if command -q ols
        abbr -a ols_update "set --local current_dir \$PWD; cd $(dirname $(realpath $(which ols))) && git pull --recurse-submodules --jobs=10; cd \$current_dir"
    end
end
