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
		require("go").setup({
			lsp_inlay_hints = {
				enable = true, -- this is the only field apply to neovim > 0.10

				-- following are used for neovim < 0.10 which does not implement inlay hints
				-- hint style, set to 'eol' for end-of-line hints, 'inlay' for inline hints
				style = "inlay",
				-- Note: following setup only works for style = 'eol', you do not need to set it for 'inlay'
				-- Only show inlay hints for the current line
				only_current_line = false,
				-- Event which triggers a refersh of the inlay hints.
				-- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
				-- not that this may cause higher CPU usage.
				-- This option is only respected when only_current_line and
				-- autoSetHints both are true.
				only_current_line_autocmd = "CursorHold",
				-- whether to show variable name before type hints with the inlay hints or not
				-- default: false
				show_variable_name = true,
				-- prefix for parameter hints
				parameter_hints_prefix = "󰊕 ",
				show_parameter_hints = true,
				-- prefix for all the other hints (type, chaining)
				other_hints_prefix = "=> ",
				-- whether to align to the length of the longest line in the file
				max_len_align = false,
				-- padding from the left if max_len_align is true
				max_len_align_padding = 1,
				-- whether to align to the extreme right or not
				right_align = false,
				-- padding from the right if right_align is true
				right_align_padding = 6,
				-- The color of the hints
				highlight = "Comment",
			},
		})
		-- Run gofmt + goimports on save
		local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				require("go.format").goimports()
			end,
			group = format_sync_grp,
		})

		-- vim.diagnostic.config({ virtual_text = false })
	end,
}
