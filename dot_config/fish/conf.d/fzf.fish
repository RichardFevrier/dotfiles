if command -q fzf

    function __fzf_default_command

        set --local binary $argv[1]
        set --local query $argv[2]

        # set --local final_output ""

        set --local fd_output "$(fd --follow --hidden --ignore-file ~/.ignore --absolute-path --color never --regex -- $query)"
        if test $binary = false
            set fd_output "$(echo -e $fd_output | xargs -d "\n" file --mime-type | grep -E 'text|json' | sed 's/:\s*\S*$//g')"
        end

        set --local final_output $fd_output

        if test -n "$query"
            set --local rg_glob_option
            while read -l line
                if test -n "$line"
                    set rg_glob_option $rg_glob_option --glob \'!$line\'
                end
            end < ~/.ignore
            set --local rg_output "$(rg $rg_glob_option --no-binary --follow --hidden --no-heading --line-number --column --no-messages --color never --context=0 --max-columns=240 -- $query)"
            set rg_output "$(echo $rg_output | sed /WARNING/d)"
            set rg_output "$(string replace --all '\n' '' $rg_output | string replace --all '\r' '')"

            if test -n "$rg_output"
                if test -n "$final_output"
                    set final_output $final_output\n
                end
                set final_output $final_output$rg_output
            end
        end


        # set --local fd_options
        # if test $binary = true
        #     # set --local fd_options
        #     # if test -z "$query"
        #     #     set fd_options --type dir
        #     # end
        # end

#         set --local fd_output "$(fd --follow --hidden --ignore-file ~/.ignore --full-path --color never --regex -- $query)"
#         if test $binary = false
#             set fd_output (echo $fd_output | xargs -d "\n" file --mime-type | grep text | sed 's/:\s*\S*$//g')
#         end
#
#         set --local final_output $fd_output
# #         if test $binary = true; and test -z "$query"
# #             set rg_options --binary
# #         else
# #             set rg_options --no-binary
# #         end
#         if test -n "$query"
#             set --local rg_options
#             set rg_options --no-binary
#             set rg_options $rg_options --context=0 --max-columns=240 -- "$query"
# #         else
# #             set rg_options $rg_options --files
#             set --local rg_output "$(rg --follow --hidden --no-heading --line-number --column --no-messages --color never $rg_options)"
#             set rg_output "$(echo $rg_output | sed /WARNING/d)"
#             set rg_output "$(string replace --all '\n' '' $rg_output | string replace --all '\r' '')"
#
#             if test -n "$rg_output"
#                 if test -n "$final_output"
#                     set final_output $final_output\n
#                 end
#                 set final_output $final_output$rg_output
#             end
#         end
#
#         if test -n "$query"
#             set rg_output "$(string replace --all '\n' '' $rg_output | string replace --all '\r' '')"
#         end

        # set --local final_output "$binary"
        # set --local final_output "rg --follow --hidden --no-heading --line-number --column --no-messages --color never $rg_options"

        # set --local final_output "pouet"

        # if test -n "$fd_output"
        #     if test -n "$final_output"
        #         set final_output $final_output\n
        #     end
        #     set final_output $final_output$fd_output
        #     # set final_output $final_output"fd --follow --hidden --full-path --color never --regex $fd_options -- $query"
        # end

#         echo $fd_output | while read --local fd_path
#             if test -z "$fd_path"
#                 break
#             end
#             # if string match --quiet "*/" -- $fd_path
#             #     continue
#             # end
#
#             if not string match --quiet "*$fd_path*" -- $rg_output
#                 if test -n "$final_output"
#                     set final_output $final_output\n
#                 end
#                 set final_output $final_output$fd_path
#             end
#         end
#
        if test -z "$final_output"
            echo "No results found."
            return
        end

        echo -e "$final_output" | sort --ignore-case --version-sort
    end

    function __fzf_previewers

        set --local infos (string match --regex --groups-only "(.+?):(\d+):(\d+):.+|(.+)" -- $argv)
        set --local path $infos[1]
        set --local ftype (file --brief --mime-type -- $path)
        # set --local hash (md5sum $path | cut -d ' ' -f 1)

        switch $ftype
            case "*directory*"
                tree $path
            case "*image*"
                if type -q chafa
                    chafa -f sixel -s {$FZF_PREVIEW_COLUMNS}x{$FZF_PREVIEW_LINES} -- $path
                end
            case "*video*"
                if type -q ffmpegthumbnailer
                    set --local tmp (mktemp -t "fzf_previewer_videos.XXXXXX.png")
                    ffmpegthumbnailer -i $path -o $tmp -s 0 >/dev/null 2>&1
                    if type -q chafa
                        chafa -f sixel -s {$FZF_PREVIEW_COLUMNS}x{$FZF_PREVIEW_LINES} -- $tmp
                    end
                end
            case "*"
                if type -q bat
                    # set --local query $raw_infos[1]
                    set --local line_number $infos[2]

                    if test -n "$line_number"
                        set --local start_line "0"
                        if test (math "$line_number - 20") -gt $start_line
                            set start_line (math "$line_number - 20")
                        end
                        set --local end_line (wc -l < $path)
                        if test (math "$line_number + 20") -lt $end_line
                            set end_line (math "$line_number + 20")
                        end

                        # bat --style=numbers --color=always --highlight-line $line_number --pager="less -R +$line_number" -- $path # | sed "s/\($query\)/\x1b[31m\1\x1b[0m/g"  ## pager not working inside fzf
                        bat --style=numbers --color=always --highlight-line $line_number --line-range $start_line:$end_line -- $path # | sed "s/\($query\)/\x1b[31m\1\x1b[0m/g"
                    else
                        bat --style=numbers --color=always -- $path
                    end
                    return
                end
                cat $path
        end
    end

    function __fzf_proxy

        set --local args (string split "\n" $argv)
        set --local binary $args[1]
        set --local multi $args[2]

        fzf --bind "start:reload:__fzf_default_command $binary {q}" \
            --bind "change:reload:sleep 0.1; __fzf_default_command $binary {q}" \
            --layout=reverse \
            --preview "__fzf_previewers {}" \
            --preview-window=right:38% \
            --$multi \
            --disabled \
            --bind "shift-up:toggle+up,shift-down:toggle+down,ctrl-a:select-all,esc:deselect-all" \
            --bind "ctrl-c:execute-silent:echo {+} | wl-copy --trim-newline" \
            --bind "ctrl-v:transform-query:wl-paste"
    end

    function f
        argparse micro= yazi= -- $argv
        # exit if argparse failed because it found an option it didn't recognize - it will print an error
        or return

        set --local binary true
        if set -ql _flag_micro
            set binary false
        end

        set --local multi multi
        if set -ql _flag_yazi
            set multi no-multi
        end

        set --local raw_infos "$(__fzf_proxy $binary -- $multi)"
        # echo -e $raw_infos
        # return

        set --local paths ""
        set --local micro_paths ""
        set --local ftypes ""

        echo "$raw_infos" | while read --local raw_info
            if test -z "$raw_info"
                break
            end

            set --local infos (string match --regex --groups-only "(.+?):(\d+):(\d+):.+|(.+)" -- $raw_info)
            set --local path $infos[1]
            set --local line_number $infos[2]
            set --local column_number $infos[3]
            set --local ftype (file --brief --mime-type -- $path)

            if string match --quiet "*$path*" -- $paths
                continue
            end

            if test -n "$paths"
                set paths "$paths\n"
            end
            set paths "$paths$path"

            if test -n "$micro_paths"
                set micro_paths "$micro_paths\n"
            end
            set micro_paths "$micro_paths$path"

            if test -n "$line_number"; and test -n "$column_number"
                set micro_paths "$micro_paths:$line_number:$column_number"
            end

            switch $ftype
                case "*text*"
                    set ftype "text"
                case "*json*"
                    set ftype "text"
            end

            if not string match --quiet "*$ftype*" -- $ftypes
                if test -n "$ftypes"
                    set ftypes $ftypes\n
                end
                set ftypes $ftypes$ftype
            end
        end

        if test -z "$paths"
            return
        end

        if set -ql _flag_micro
            echo -e "$micro_paths" > "$_flag_micro"
            return
        end

        if set -ql _flag_yazi
            echo -e "$paths"
            return
        end

        set --local number_of_types (echo -e "$ftypes" | wc -l)

        if test $number_of_types -eq 1; and test "$ftypes" = "text"
            if type -q micro
                micro (string split "\n" -- $micro_paths)
                return
            end
            nano (string split "\n" -- $paths)
            return
        end

        set --local number_of_paths (echo -e "$paths" | wc -l)

        if test $number_of_paths -eq 1;
            if type -q yazi
                y $paths
                return
            end

            if test -d "$paths"
                builtin cd $paths
                return
            end

            builtin cd (dirname $paths)
            return
        end

        echo -e "$paths"
    end

    fzf --fish | source
end
