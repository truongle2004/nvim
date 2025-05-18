---@diagnostic disable: undefined-global
return {
	"craftzdog/solarized-osaka.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
	       require('solarized-osaka').setup({
	           transparent = true
	       })
		vim.cmd([[colorscheme solarized-osaka]])
	end,
}
