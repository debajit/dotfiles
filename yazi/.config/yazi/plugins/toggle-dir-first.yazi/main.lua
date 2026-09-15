--- @sync entry

return {
	entry = function()
		ya.emit("sort", { dir_first = not cx.active.pref.sort_dir_first })
	end,
}
