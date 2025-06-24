local shell = import("micro/shell")
local config = import("micro/config")

function fzfcommand(bp, args)
    local tmp, err = shell.RunCommand("mktemp -t 'micro-fzf.XXXXXX'")
    if err == nil then
        local output, err = shell.RunInteractiveShell("fish -c 'f --micro="..tmp.."'", false, false)
        if err == nil then
            local output, err = shell.RunCommand("cat "..tmp)
            if err == nil then
                fzfOutput(output, {bp})
            end
        end
    end
    shell.RunCommand("rm -f "..tmp)
end

function fzfOutput(output, args)
    local bp = args[1]

    if output ~= "" then
        for file in output:gmatch("[^\r\n]+") do
            bp:NewTabCmd({file})
        end
    end
end

function init()
    config.MakeCommand("fzfcommand", fzfcommand, config.NoComplete)
end
