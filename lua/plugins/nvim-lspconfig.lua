return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",

		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		{ "nvim-lua/plenary.nvim" },
	},

	config = function()
		-- import lspconfig plugin

		local lspconfig = require("lspconfig")

		local util = require("lspconfig.util")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		lspconfig.jdtls.setup({
			capabilities = capabilities,
		})

        lspconfig.templ.setup({
            capabilities = capabilities,
        })

		lspconfig.yamlls.setup({
			capabilities = capabilities,
		})

		lspconfig.gopls.setup({
			capabilities = capabilities,
		})

		lspconfig.tailwindcss.setup({
			capabilities = capabilities,
		})

		lspconfig.htmx.setup({
			capabilities = capabilities,
		})

		-- local pyright_restarted = false
		--
		-- lspconfig.pyright.setup({
		-- 	capabilities = capabilities,
		-- 	on_init = function(client)
		-- 		if not pyright_restarted then -- Only proceed if we haven't restarted yet
		-- 			local cwd = vim.fn.getcwd()
		-- 			local venv_path = find_venv(cwd)
		-- 			if venv_path then
		-- 				print("Venv folder found: " .. venv_path)
		-- 				vim.env.VIRTUAL_ENV = venv_path
		-- 				vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
		--
		-- 				-- Set the flag to true
		-- 				pyright_restarted = true
		--
		-- 				vim.schedule(function()
		-- 					vim.cmd("LspRestart pyright")
		-- 					print("Pyright restarted with new venv settings")
		-- 				end)
		-- 			else
		-- 				print("No venv folder found in or one level below current directory: " .. cwd)
		-- 			end
		-- 		end
		-- 		return true
		-- 	end,
		-- })
		--
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
		})

		local customizations = {
			{ rule = "style/*", severity = "off", fixable = true },
			{ rule = "format/*", severity = "off", fixable = true },

			{ rule = "*-indent", severity = "off", fixable = true },
			{ rule = "*-spacing", severity = "off", fixable = true },
			{ rule = "*-spaces", severity = "off", fixable = true },
			{ rule = "*-order", severity = "off", fixable = true },

			{ rule = "*-dangle", severity = "off", fixable = true },
			{ rule = "*-newline", severity = "off", fixable = true },
			{ rule = "*quotes", severity = "off", fixable = true },
			{ rule = "*semi", severity = "off", fixable = true },
		}

		lspconfig.eslint.setup({

			-- on_attach = function(client, bufnr)
			--   vim.api.nvim_create_autocmd("BufWritePre", {
			--     buffer = bufnr,
			--     command = "EslintFixAll",
			--   })
			-- end,

			root_dir = util.root_pattern(
				".eslintrc",
				".eslintrc.js",
				".eslintrc.cjs",

				".eslintrc.yaml",
				".eslintrc.yml",
				".eslintrc.json"
				-- Disabled to prevent "No ESLint configuration found" exceptions
				-- 'package.json',
			),
			filetypes = {

				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
				"vue",
				"html",
				"markdown",
				"json",
				"jsonc",
				"yaml",
				"toml",
				"xml",
				"gql",
				"graphql",
				"astro",
				"svelte",

				"css",

				"less",
				"scss",
				"pcss",
				"postcss",
			},
			settings = {
				-- Silent the stylistic rules in you IDE, but still auto fix them
				rulesCustomizations = customizations,
			},
		})

		lspconfig.html.setup({
			capabilities = capabilities,
		})
		lspconfig.cssls.setup({
			capabilities = capabilities,
		})
	end,

	-- "neovim/nvim-lspconfig",
	-- dependencies = { "saghen/blink.cmp" },
	--
	-- opts = {
	-- 	servers = {
	-- 		lua_ls = {},
	-- 		tailwindcss = {},
	-- 		svelte = {},
	-- 		gopls = {
	-- 			-- settings = {
	-- 			-- 	gopls = {
	-- 			-- 		["ui.inlayhint.hints"] = {
	-- 			-- 			compositeLiteralFields = true,
	-- 			-- 			constantValues = true,
	-- 			-- 			parameterNames = true,
	-- 			-- 		},
	-- 			-- 	},
	-- 			-- },
	-- 		},
	-- 		cssls = {},
	-- 	},
	-- },
	--
	-- config = function(_, opts)
	-- 	local lspconfig = require("lspconfig")
	-- 	for server, config in pairs(opts.servers) do
	--            require("blink.cmp").setup({
	--                windows = {
	--                    ghost_text = {
	--                        enable = true
	--                    }
	--                }
	--            })
	-- 		config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
	-- 		lspconfig[server].setup(config)
	-- 	end
	-- end,
}
