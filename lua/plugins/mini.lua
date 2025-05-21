return {
	"echasnovski/mini.nvim",
	event = "VeryLazy",
	dependencies = {},
	version = "*",
	config = function()
		-- require("mini.comment").setup()
		require("mini.move").setup()
		require("mini.indentscope").setup()
		require("mini.animate").setup({
			scroll = {
				enable = false,
			},
		})
		-- require("mini.statusline").setup()
		require("mini.pairs").setup()
		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})

		require("mini.diff").setup()
		-- require("mini.diff").setup({
		-- 	-- Options for how hunks are visualized
		-- 	view = {
		-- 		-- Visualization style. Possible values are 'sign' and 'number'.
		-- 		-- Default: 'number' if line numbers are enabled, 'sign' otherwise.
		-- 		style = "sign",
		--
		-- 		-- Signs used for hunks with 'sign' view
		-- 		signs = { add = "+", change = "~", delete = "-" },
		--
		-- 		-- Priority of used visualization extmarks
		-- 		priority = 199,
		-- 	},
		-- 	-- Module mappings. Use `''` (empty string) to disable one.
		-- 	mappings = {
		-- 		-- Apply hunks inside a visual/operator region
		-- 		apply = "gh",
		--
		-- 		-- Reset hunks inside a visual/operator region
		-- 		reset = "gH",
		--
		-- 		-- Hunk range textobject to be used inside operator
		-- 		-- Works also in Visual mode if mapping differs from apply and reset
		--
		-- 		textobject = "gh",
		--
		-- 		-- Go to hunk range in corresponding direction
		-- 		goto_first = "[H",
		-- 		goto_prev = "[h",
		--
		-- 		goto_next = "]h",
		-- 		goto_last = "]H",
		-- 	},
		--
		-- 	-- Various options
		--
		-- 	options = {
		-- 		-- Diff algorithm. See `:h vim.diff()`.
		-- 		algorithm = "histogram",
		--
		-- 		-- Whether to use "indent heuristic". See `:h vim.diff()`.
		-- 		indent_heuristic = true,
		--
		-- 		-- The amount of second-stage diff to align lines (in Neovim>=0.9)
		--
		-- 		linematch = 60,
		--
		-- 		-- Whether to wrap around edges during hunk navigation
		-- 		wrap_goto = false,
		-- 	},
		-- })
	end,
}
