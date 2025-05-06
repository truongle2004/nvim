return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	opts = {},
	config = function()
		local api = require("typescript-tools.api")
		require("typescript-tools").setup({
			handlers = {
				["textDocument/publishDiagnostics"] = api.filter_diagnostics(
					-- Ignore 'This may be converted to an async function' diagnostics.
					{ 80006 }
				),
			},
			settings = {
				jsx_close_tag = {
					enable = true,
					filetypes = { "javascriptreact", "typescriptreact" },
				},
				-- tsserver_file_preferences = {
				-- 	-- includeInlayParameterNameHints = "all",
				-- },
			},
		})
	end,
}
