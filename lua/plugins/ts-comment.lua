---@diagnostic disable:undefined-global

return {
	"folke/ts-comments.nvim",
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", "numToStr/Comment.nvim" },
	opts = {},
	event = "VeryLazy",
	enabled = vim.fn.has("nvim-0.10.0") == 1,
	config = function()
		require("ts_context_commentstring.internal").update_commentstring()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
}
