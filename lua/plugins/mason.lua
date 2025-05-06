return {
	"williamboman/mason.nvim",
	opts = {
		ensure_installed = {
			"lua-language-server",

			"stylua",
			"prettier",
			"eslint",

			"typescript-language-server",
		},
	},
}
