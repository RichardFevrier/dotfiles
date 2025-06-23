local selected_or_hovered = ya.sync(function()
	local paths = {}
	local tab = cx.active
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths < 2 and tab.current.hovered then
		paths[2] = tostring(tab.current.hovered.url)
	end
	return paths
end)

local function entry()

    local urls = selected_or_hovered()
    if not urls[1] or not urls[2] then
        return ya.notify { title = "Delta", content = "Need to select at least two files", timeout = 5, level = "warn" }
    end

    ya.dbg("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")

    ya.dbg(urls[1])
    ya.dbg(urls[2])

    -- ya.dbg("-c echo delta "..urls[1].." "..urls[2].."| wl-copy")
    -- return ya.notify { title = "Delta", content = urls, timeout = 5, level = "warn" }

    -- local _permit = ya.hide()
    -- local cwd = tostring(state())

    -- ya.err("-c 'delta "..urls[1].." "..urls[2].."'")
		-- :cwd(tostring(cwd))
		-- :stdin(#selected > 0 and Command.PIPED or Command.INHERIT)
        -- :stdin(Command.INHERIT)

  --   local output, err = Command("echo")
  --       :arg("'$SHELL'")
		-- :output()

    local cmd = "'delta "..urls[1].." "..urls[2].."'"
    ya.dbg(cmd)

         -- 'delta "..urls[1].." "..urls[2].."'")

    local child, err = Command("fish")
        :arg("-c")
        :arg(cmd)
		:stdout(Command.PIPED)
		:spawn()

        -- :arg(urls[1])
        -- :arg(urls[2])
        -- :arg("--paging")
        -- :arg("always")
--
	ya.dbg(child)
	ya.dbg(err)
--
	local output, err = child:wait_with_output()
	ya.dbg(output.stdout)
    ya.dbg(err)
  --   local child, err = Command("delta "..urls[1].." "..urls[2]):cwd(cwd):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()

    -- local child, err = Command("fish"):arg("-c echo "..urls[1]):cwd(cwd):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
    -- local child, err = Command("echo "..urls[1].." "..urls[2].."| wl-copy"):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
--     local child, err = Command("delta"):arg(urls[1]):arg(urls[2]):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
--
--     ya.dbg(child)
--     ya.dbg(err)
--
--     if err == nil then
--         local output, err = child:wait()
--     end

    -- local selection = ya.selection()
    -- ya.err(job.file.url)





    -- for _, arg in ipairs(args) do
    --     ya.err(arg)
    -- end

    -- for as in job.args do
    --     ya.err("selection")
    -- end

--     local selection = ui.selection()
--
--     ya.err(selection)

    -- ya.err("Hello", "World!")
-- 	local _permit = ya.hide()
-- 	local cwd = tostring(state())
--
-- 	local h = cx.active.current.hovered
-- 	ya.dbg(h)


-- 	local child, err = Command("delta"):arg(""..tmp):cwd(cwd):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
--
--
--     local output, err = Command("mktemp"):args({ "-t", "yazi-fzf.XXXXXX" }):output()
--     if err == nil then
--         local tmp = output.stdout
--
--         local child, err = Command("fish"):arg("-c f --yazi="..tmp):cwd(cwd):stdin(Command.INHERIT):stdout(Command.PIPED):stderr(Command.INHERIT):spawn()
--         if err == nil then
--             local output, err = child:wait_with_output()
--             if err == nil then
--                 local output, err = Command("fish"):arg("-c cat "..tmp):output()
--                 if err == nil then
--                 	local target = output.stdout:gsub("\n$", "")
--                 	if target ~= "" then
--                 		ya.manager_emit(target:find("[/\\]$") and "cd" or "reveal", { target })
--                 	end
--                 end
--             end
--         end
--         Command("fish"):arg("-c rm "..tmp):output()
--     end
end

return { entry = entry }
