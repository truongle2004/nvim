---@diagnostic disable: undefined-field
---@diagnostic disable: undefined-global

vim.loader.enable()

vim.g.projects_dir = vim.env.HOME .. "/home/lesytruong/projects/"

-- vim.cmd.colorscheme("miss-dracula")
-- local function find_venv(start_path) -- Finds the venv folder required for LSP
-- 	-- Check current directory (if venv folder is at root)
-- 	local venv_path = start_path .. "/venv"
-- 	if vim.fn.isdirectory(venv_path) == 1 then
-- 		return venv_path
-- 	end
-- 	-- Check one level deeper (e.g if venv is in proj/venv)
-- 	local handle = vim.loop.fs_scandir(start_path)
-- 	if handle then
-- 		while true do
-- 			local name, type = vim.loop.fs_scandir_next(handle)
-- 			if not name then
-- 				break
-- 			end
-- 			if type == "directory" then
-- 				venv_path = start_path .. "/" .. name .. "/venv"
-- 				if vim.fn.isdirectory(venv_path) == 1 then
-- 					return venv_path
-- 				end
-- 			end
-- 		end
-- 	end
--
-- 	return nil
-- end
--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp = vim.opt.rtp ^ lazypath

---@type LazySpec
local plugins = "plugins"

require("settings")
require("keymaps")
-- require("statusline")
require("commands")
require("auto_cmds")
-- require("winbar")
require("lsp")

-- Configureplugins.
require("lazy").setup(plugins, {
	ui = { border = "rounded" },
	dev = { path = vim.g.projects_dir },
	install = {
		-- Do not automatically install on startup.
		missing = false,
	},
	-- Don't bother me when tweaking plugins.
	change_detection = { notify = false },
	-- None of my plugins use luarocks so disable this.
	rocks = {
		enabled = false,
	},
	performance = {
		rtp = {
			-- Stuff I don't use.
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"rplugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- Change the cursor shape (should be in last line)
-- vim.opt.guicursor = ""
