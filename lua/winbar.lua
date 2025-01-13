local folder_icon = require("icons").symbol_kinds.Folder

local M = {}

--- Window bar that shows the current file path (in a fancy way).
---@return string
function M.render()
	-- Get the path and expand variables.
	local path = vim.fs.normalize(vim.fn.expand("%:p"))

	-- Replace slashes with arrows.
	local separator = " %#WinbarSeparator# "

	local prefix, prefix_path = "", ""

	-- If the window gets too narrow, shorten the path and drop the prefix.
	if vim.api.nvim_win_get_width(0) < math.floor(vim.o.columns / 3) then
		path = vim.fn.pathshorten(path)
	else
		-- For some special folders, add a prefix instead of the full path (making
		-- sure to pick the longest prefix).
		local special_dirs = {
			CODE = vim.g.projects_dir,
			DOTFILES = vim.fn.stdpath("config"),
			HOME = vim.env.HOME,
			PERSONAL = vim.g.personal_projects_dir,
		}

		for dir_name, dir_path in pairs(special_dirs) do
			if vim.startswith(path, vim.fs.normalize(dir_path)) and #dir_path > #prefix_path then
				prefix, prefix_path = dir_name, dir_path
			end
		end

		if prefix ~= "" then
			path = path:gsub("^" .. vim.pesc(prefix_path), "")
			prefix = string.format("%%#WinBarSpecial#%s %s%s", folder_icon, prefix, separator)
		end
	end

	-- Remove leading slash.
	path = path:gsub("^/", "")

	-- Split the path and apply formatting to each segment.
	local path_segments = vim.split(path, "/")
	local formatted_segments = {}

	for _, segment in ipairs(path_segments) do
		table.insert(formatted_segments, string.format("%%#Winbar#%s", segment))
	end

	return table.concat({
		" ",
		prefix,
		table.concat(formatted_segments, separator),
	})
end

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("mariasolos/winbar", { clear = true }),
	desc = "Attach winbar",
	callback = function(args)
		if
			not vim.api.nvim_win_get_config(0).zindex -- Not a floating window
			and vim.bo[args.buf].buftype == "" -- Normal buffer
			and vim.api.nvim_buf_get_name(args.buf) ~= "" -- Has a file name
			and not vim.wo[0].diff -- Not in diff mode
		then
			vim.wo.winbar = "%{%v:lua.require'winbar'.render()%}"
		end
	end,
})

return M
