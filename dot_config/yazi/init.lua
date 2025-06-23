require("starship"):setup()

function Linemode:mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	else
	    time = os.date("%d %b %Y at %H:%M", time)
	end
	return ui.Line(string.format("%s", time))
end
