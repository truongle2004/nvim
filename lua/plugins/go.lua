---@diagnostic disable: undefined-global
return {
	"ray-x/go.nvim",
	ft = { "go", "gomod" },
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
	},

	event = { "CmdlineEnter" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
	config = function()
		require("go").setup({})
		-- Run gofmt + goimports on save
		local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				require("go.format").goimports()
			end,
			group = format_sync_grp,
		})

		vim.diagnostic.config({ virtual_text = false })
	end,
}
