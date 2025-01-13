vim.loader.enable()
---@diagnostic disable: undefined-global
--@diagnostic disable: missing-fields
--@diagnostic disable: missing-fields, param-type-mismatch, undefined-field vim.loader.enable()
--

local function find_venv(start_path) -- Finds the venv folder required for LSP
    -- Check current directory (if venv folder is at root)
    local venv_path = start_path .. "/venv"
    if vim.fn.isdirectory(venv_path) == 1 then
        return venv_path
    end
    -- Check one level deeper (e.g if venv is in proj/venv)
    local handle = vim.loop.fs_scandir(start_path)
    if handle then
        while true do
            local name, type = vim.loop.fs_scandir_next(handle)
            if not name then
                break
            end
            if type == "directory" then
                venv_path = start_path .. "/" .. name .. "/venv"
                if vim.fn.isdirectory(venv_path) == 1 then
                    return venv_path
                end
            end
        end
    end

    return nil
end

if vim.g.neovide then
    -- vim.o.guifont = "FiraCode Nerd Font:h10"
    -- vim.o.guifont = "ZedMono Nerd Font :h10"
    vim.o.guifont = ":h10"
end


-- vim.cmd([[set foldmethod=indent]])

-- vim.cmd[[colorscheme retrobox]]

local opt = vim.opt
vim.o.spelllang = "en_us"
vim.o.spell = false
vim.g.mapleader = " "
opt.shellquote = ""
opt.shellxquote = ""
opt.termguicolors = true
opt.relativenumber = true
opt.number = true
opt.scrolloff = 10
opt.laststatus = 3
vim.o.undofile = true

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4",
})
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "cpp",
-- 	command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4",
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "python",
-- 	command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4",
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "rust",
-- 	command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4",
-- })
--

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    callback = function()
        -- Map <F9> to compile the current file
        vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<F9>",
            ":w<bar>!g++ -std=c++14 % -o %:r -Wl,--stack,268435456<CR>",
            { noremap = true, silent = true }
        )
        -- Map <F10> to execute the compiled file
        vim.api.nvim_buf_set_keymap(0, "n", "<F10>", ":!%:r<CR>", { noremap = true, silent = true })
    end,
})

opt.expandtab = true
opt.autoindent = true

opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.backspace = "indent,eol,start"
-- opt.clipboard:append("unnamedplus")
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
opt.swapfile = false
opt.splitbelow = true -- split windows below
-- opt.colorcolumn = "79"
opt.splitright = true -- split windows right
vim.o.wrap = true
opt.spelllang = "en_us"

vim.o.syntax = "off"

-- Enable lazyredraw for better performance during macros and complex operations
vim.o.lazyredraw = true

-- Assume fast terminal connection
vim.o.ttyfast = true

-- Set the update time for writing to the swap file and triggering CursorHold events (in milliseconds)
vim.o.updatetime = 300

vim.o.termguicolors = true

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_zipPlugin = 1

-- vim.cmd.colorscheme("retrobox")

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

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- { "nvim-java/nvim-java", ft = { "java" } },
    {
        "ray-x/go.nvim",
        ft = { "go", "gomod" },
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
        },

        event = { "CmdlineEnter" },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
        config = function()
            require("go").setup()
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

    },
    -- {
    -- 	"rcarriga/nvim-dap-ui",
    -- 	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    -- 	config = function()
    -- 		require("dapui").setup()
    -- 	end,
    -- },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require("lsp_signature").setup({
                doc_lines = 0,
                handler_opts = {
                    border = "none",
                },
            })
        end,
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy", -- Or `LspAttach`
        priority = 1000,    -- needs to be loaded in first
        config = function()
            require("tiny-inline-diagnostic").setup()
        end,
    },

    -- {
    -- 	"catppuccin/nvim",
    -- 	name = "catppuccin",
    -- 	priority = 1000,
    -- 	config = function()
    -- 		vim.cmd.colorscheme("catppuccin")
    -- 	end,
    -- },
    {
        "wincent/base16-nvim",
        lazy = false,    -- load at start
        priority = 1000, -- load first
        config = function()
            vim.cmd([[colorscheme gruvbox-dark-hard]])
            vim.o.background = "dark"
            -- XXX: hi Normal ctermbg=NONE
            -- Make comments more prominent -- they are important.
            local bools = vim.api.nvim_get_hl(0, { name = "Boolean" })
            vim.api.nvim_set_hl(0, "Comment", bools)
            -- Make it clearly visible which argument we're at.
            local marked = vim.api.nvim_get_hl(0, { name = "PMenu" })
            vim.api.nvim_set_hl(
                0,
                "LspSignatureActiveParameter",
                { fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true }
            )
            -- XXX
            -- Would be nice to customize the highlighting of warnings and the like to make
            -- them less glaring. But alas
            -- https://github.com/nvim-lua/lsp_extensions.nvim/issues/21
            -- call Base16hi("CocHintSign", g:base16_gui03, "", g:base16_cterm03, "", "", "")
        end,
    },
    -- {
    -- 	"folke/tokyonight.nvim",
    -- 	lazy = false,
    -- 	priority = 1000,
    -- 	opts = {},
    --        config = function()
    --            -- require('tokyonight').setup({
    --            --     transparent = true
    --            -- })
    --            vim.cmd([[colorscheme tokyonight]])
    --        end
    -- },
    -- {
    --     "craftzdog/solarized-osaka.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         vim.o.background = "dark"
    --         require("solarized-osaka").setup({
    --             transparent = true,
    --         })
    --         vim.cmd([[colorscheme solarized-osaka]])
    --     end,
    -- },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                },
            })
        end,
    },
    -- {
    -- 	"folke/trouble.nvim",
    -- 	opts = {}, -- for default options, refer to the configuration section for custom setup.
    -- 	cmd = "Trouble",
    -- 	keys = {
    -- 		{
    -- 			"<leader>xx",
    -- 			"<cmd>Trouble diagnostics toggle<cr>",
    -- 			desc = "Diagnostics (Trouble)",
    -- 		},
    -- 		{
    -- 			"<leader>xX",
    -- 			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    -- 			desc = "Buffer Diagnostics (Trouble)",
    -- 		},
    -- 		{
    -- 			"<leader>cs",
    -- 			"<cmd>Trouble symbols toggle focus=false<cr>",
    -- 			desc = "Symbols (Trouble)",
    -- 		},
    -- 		{
    -- 			"<leader>cl",
    -- 			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    -- 			desc = "LSP Definitions / references / ... (Trouble)",
    -- 		},
    -- 		{
    -- 			"<leader>xL",
    -- 			"<cmd>Trouble loclist toggle<cr>",
    -- 			desc = "Location List (Trouble)",
    -- 		},
    -- 		{
    -- 			"<leader>xQ",
    -- 			"<cmd>Trouble qflist toggle<cr>",
    -- 			desc = "Quickfix List (Trouble)",
    -- 		},
    -- 	},
    -- },
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescriptreact = { "prettier" },
                    css = { "prettier" },
                    html = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },
                    graphql = { "prettier" },
                    liquid = { "prettier" },
                    lua = { "stylua" },
                    cpp = { "clang-format" },
                    python = { "black" },
                    xml = { "xmlformatter" },
                },
            })

            vim.keymap.set({ "n", "v" }, "<leader>mp", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end, { desc = "Format file or range (in visual mode)" })
        end,
    },
    {
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
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",

            { "antosha417/nvim-lsp-file-operations", config = true },
            { "folke/neodev.nvim",                   opts = {} },
            { "nvim-lua/plenary.nvim" },
        },

        config = function()
            -- require("java").setup()
            -- import lspconfig plugin

            local lspconfig = require("lspconfig")

            local util = require("lspconfig.util")

            -- import cmp-nvim-lsp plugin
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            -- used to enable autocompletion (assign to every lsp server config)
            local capabilities = cmp_nvim_lsp.default_capabilities()

            -- lspconfig.jdtls.setup({
            -- 	capabilities = capabilities,
            -- })

            lspconfig.yamlls.setup({
                capabilities = capabilities,
            })

            lspconfig.templ.setup({
                capabilities = capabilities,
            })

            lspconfig.gopls.setup({})

            lspconfig.htmx.setup({
                capabilities = capabilities,
                filetypes = { "html", "templ" },
            })

            local pyright_restarted = false

            lspconfig.pyright.setup({
                capabilities = capabilities,
                on_init = function(client)
                    if not pyright_restarted then -- Only proceed if we haven't restarted yet
                        local cwd = vim.fn.getcwd()
                        local venv_path = find_venv(cwd)
                        if venv_path then
                            print("Venv folder found: " .. venv_path)
                            vim.env.VIRTUAL_ENV = venv_path
                            vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH

                            -- Set the flag to true
                            pyright_restarted = true

                            vim.schedule(function()
                                vim.cmd("LspRestart pyright")
                                print("Pyright restarted with new venv settings")
                            end)
                        else
                            print("No venv folder found in or one level below current directory: " .. cwd)
                        end
                    end
                    return true
                end,
            })

            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = {
                    "D:\\main\\gcc\\winlibs-x86_64-mcf-seh-gcc-13.2.0-llvm-16.0.6-mingw-w64ucrt-11.0.1-r2\\mingw64\\bin\\clangd.exe", -- Full path to clangd on Windows
                    "--background-index",                                                                                             -- Enable background indexing
                    "--pch-storage=memory",                                                                                           -- Use memory for precompiled headers
                    "--all-scopes-completion",                                                                                        -- Complete across all available scopes
                    "--pretty",                                                                                                       -- Pretty-print diagnostics
                    "--header-insertion=never",                                                                                       -- Disable automatic header insertion
                    "-j=4",                                                                                                           -- Limit number of parallel jobs
                    "--function-arg-placeholders=false",                                                                              -- Disable function argument placeholders
                    "--completion-style=detailed",                                                                                    -- Provide detailed completion information
                    "--log=verbose",                                                                                                  -- (Optional) Enable verbose logging for debugging
                },
                on_attach = function(client)
                    client.server_capabilities.inlayHintProvider = false
                end,
            })

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = {
                                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                                [vim.fn.expand("${3rd}/love2d/library")] = true,
                            },
                        },
                    },
                },
            })

            local customizations = {
                { rule = "style/*",   severity = "off", fixable = true },
                { rule = "format/*",  severity = "off", fixable = true },

                { rule = "*-indent",  severity = "off", fixable = true },
                { rule = "*-spacing", severity = "off", fixable = true },
                { rule = "*-spaces",  severity = "off", fixable = true },
                { rule = "*-order",   severity = "off", fixable = true },

                { rule = "*-dangle",  severity = "off", fixable = true },
                { rule = "*-newline", severity = "off", fixable = true },
                { rule = "*quotes",   severity = "off", fixable = true },
                { rule = "*semi",     severity = "off", fixable = true },
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
                filetypes = { "html", "templ" },
            })

            lspconfig.cssls.setup({
                capabilities = capabilities,
            })

            -- local function organize_imports()
            --   local params = {
            --     command = "_typescript.organizeImports",
            --     arguments = { vim.api.nvim_buf_get_name(0) },
            --   }
            --   vim.lsp.buf.execute_command(params)
            -- end
            --
            -- local vue_language_server_path = "C:/Users/truon/AppData/Roaming/npm/node_modules/@vue/language-server"

            -- lspconfig.ts_ls.setup({
            -- 	capabilities = capabilities,
            -- 	init_options = {
            -- 		plugins = {
            -- 			{
            -- 				-- Name of the TypeScript plugin for Vue
            -- 				name = "@vue/typescript-plugin",
            --
            -- 				-- Location of the Vue language server module (path defined in step 1)
            -- 				location = vue_language_server_path,
            --
            -- 				-- Specify the languages the plugin applies to (in this case, Vue files)
            -- 				languages = { "vue" },
            -- 			},
            -- 		},
            -- 	},
            -- 	commands = {
            -- 		OrganizeImports = {
            -- 			organize_imports,
            -- 			description = "Organize Imports",
            -- 		},
            -- 	}
            -- })
            --
            -- lspconfig.volar.setup({
            --      capabilities = capabilities,
            -- 	init_options = {
            -- 		vue = {
            -- 			hybridMode = false,
            -- 		},
            -- 	},
            -- })
            --
            -- lspconfig.rust_analyzer.setup({
            --   capabilities = capabilities,
            --   settings = {
            --     ["rust-analyzer"] = {
            --       cargo = {
            --         allFeatures = true,
            --       },
            --       imports = {
            --         group = {
            --           enable = false,
            --         },
            --       },
            --       completion = {
            --         postfix = {
            --           enable = false,
            --         },
            --       },
            --     },
            --   },
            -- })
        end,
    },
    -- {
    -- 	"numToStr/Comment.nvim",
    -- 	dependencies = {
    -- 		"folke/ts-comments.nvim",
    -- 		"JoosepAlviste/nvim-ts-context-commentstring",
    -- 	},
    -- 	opts = {
    -- 		-- add any options here
    -- 	},
    -- 	config = function()
    -- 		require("ts-comments").setup()
    --
    -- 		require("ts_context_commentstring").setup({
    -- 			enable_autocmd = false,
    -- 		})
    --
    -- 		require("Comment").setup({
    -- 			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    -- 		})
    -- 	end,
    -- },
    {
        "Exafunction/codeium.vim",
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        opts = {},
        config = function()
            require("typescript-tools").setup({
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
    },
    {
        "hrsh7th/nvim-cmp",

        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer", -- source for text in buffer
            "hrsh7th/cmp-path",   -- source for file system paths
            {
                "L3MON4D3/LuaSnip",
                -- follow latest release.
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
            },

            "saadparwaiz1/cmp_luasnip",     -- for autocompletion
            "rafamadriz/friendly-snippets", -- useful snippets
            "onsails/lspkind.nvim",         -- vs-code like pictograms
        },
        config = function()
            local cmp = require("cmp")

            local luasnip = require("luasnip")

            local lspkind = require("lspkind")

            -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noselect",
                },
                snippet = { -- configure how nvim-cmp interacts with snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
                    ["<C-e>"] = cmp.mapping.abort(),        -- close completion window
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                -- sources for autocompletion
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- snippets
                    { name = "buffer" },  -- text within current buffer
                    { name = "path" },    -- file system paths
                }),

                -- configure lspkind for vs-code like pictograms in completion menu

                formatting = {
                    format = lspkind.cmp_format({
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
            })

            vim.keymap.set({ "i" }, "<C-K>", function()
                luasnip.expand()
            end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-l>", function()
                luasnip.jump(1)
            end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-h>", function()
                luasnip.jump(-1)
            end, { silent = true })
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
    },
    -- {
    -- 	"nvim-tree/nvim-tree.lua",
    -- 	config = function()
    -- 		require("nvim-tree").setup({
    -- 			view = {
    -- 				width = 40,
    -- 			},
    -- 		})
    -- 	end,
    -- },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            local ignore_filetypes_list = {
                "venv",
                "__pycache__",
                "%.xlsx",
                "%.jpg",
                "%.png",
                "%.webp",
                "%.pdf",
                "%.odt",
                "%.ico",
                "%.class",
                "%.jar",
                "%.pyc",
                "%.lst",
                "node_modules",
                "targets",
                "*_templ.go",
            }

            telescope.setup({
                defaults = {
                    file_ignore_patterns = ignore_filetypes_list,
                    path_display = { "smart" },
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
                            ["<C-j>"] = actions.move_selection_next,     -- move to next result
                        },
                    },
                },
            })

            telescope.load_extension("fzf")

            -- set keymaps
            local keymap = vim.keymap -- for conciseness

            keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
            keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
            keymap.set("n", "<leader><leader>f", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
            keymap.set(
                "n",
                "<leader>fc",
                "<cmd>Telescope grep_string<cr>",
                { desc = "Find string under cursor in cwd" }
            )
        end,
    },
    -- {
    -- 	"nvim-lualine/lualine.nvim",
    -- 	dependencies = { "nvim-tree/nvim-web-devicons" },
    -- 	config = function()
    -- 		---@diagnostic disable-next-line: missing-parameter
    -- 		require("lualine").setup()
    -- 	end,
    -- },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            vim.opt.termguicolors = true
            require("bufferline").setup({})
        end,
    },
    {
        "nvim-tree/nvim-web-devicons"
    },
    -- {
    --
    --
    --     "ibhagwan/fzf-lua",
    --     dependencies = {
    --     },
    --     config = function()
    --         require("fzf-lua").setup({
    --         })
    --     end
    -- },
    {
        "echasnovski/mini.nvim",
        event = "VeryLazy",
        dependencies = {
        },
        version = "*",
        config = function()
            -- require("mini.comment").setup()

            -- require("mini.indentscope").setup()

            -- require("mini.statusline").setup()

            -- vim.cmd.colorscheme("minischeme")
            -- require("mini.tabline").setup()

            require("mini.move").setup()
            --
            require("mini.pairs").setup()
            --
            -- local hipatterns = require("mini.hipatterns")
            -- hipatterns.setup({
            -- 	highlighters = {
            -- 		-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            -- 		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            -- 		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
            -- 		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
            -- 		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
            --
            -- 		-- Highlight hex color strings (`#rrggbb`) using that color
            -- 		hex_color = hipatterns.gen_highlighter.hex_color(),
            -- 	},
            -- })
            --
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
            --
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
    },
    {
        "mrcjkb/rustaceanvim",
        ft = "rust",
        version = "^5", -- Recommended
        lazy = false,   -- This plugin is already lazy
    },
    -- {
    --     "mattn/emmet-vim",
    --     lazy = false,
    --     ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    -- },
    -- {
    --     "mg979/vim-visual-multi",
    --     lazy = false,
    -- },
    -- {
    -- 	"folke/snacks.nvim",
    -- 	priority = 1000,
    -- 	lazy = false,
    -- 	---@type snacks.Config
    -- 	opts = {
    -- 		bigfile = { enabled = true },
    -- 		dashboard = { enabled = false },
    -- 		indent = { enabled = true },
    -- 		input = { enabled = false },
    -- 		notifier = {
    -- 			enabled = false,
    -- 		},
    -- 		quickfile = { enabled = true },
    -- 		scroll = { enabled = false },
    -- 		statuscolumn = { enabled = true },
    -- 		words = { enabled = true },
    -- 		styles = {
    -- 			notification = {
    -- 				-- wo = { wrap = true } -- Wrap notifications
    -- 			},
    -- 		},
    -- 	},
    -- 	keys = {
    -- 		{
    -- 			"<leader>z",
    -- 			function()
    -- 				Snacks.zen()
    -- 			end,
    -- 			desc = "Toggle Zen Mode",
    -- 		},
    -- 		{
    -- 			"<leader>Z",
    -- 			function()
    -- 				Snacks.zen.zoom()
    -- 			end,
    -- 			desc = "Toggle Zoom",
    -- 		},
    -- 		{
    -- 			"<leader>.",
    -- 			function()
    -- 				Snacks.scratch()
    -- 			end,
    -- 			desc = "Toggle Scratch Buffer",
    -- 		},
    -- 		{
    -- 			"<leader>S",
    -- 			function()
    -- 				Snacks.scratch.select()
    -- 			end,
    -- 			desc = "Select Scratch Buffer",
    -- 		},
    -- 		{
    -- 			"<leader>n",
    -- 			function()
    -- 				Snacks.notifier.show_history()
    -- 			end,
    -- 			desc = "Notification History",
    -- 		},
    -- 		{
    -- 			"<leader>bd",
    -- 			function()
    -- 				Snacks.bufdelete()
    -- 			end,
    -- 			desc = "Delete Buffer",
    -- 		},
    -- 		{
    -- 			"<leader>cR",
    -- 			function()
    -- 				Snacks.rename.rename_file()
    -- 			end,
    -- 			desc = "Rename File",
    -- 		},
    -- 		{
    -- 			"<leader>gB",
    -- 			function()
    -- 				Snacks.gitbrowse()
    -- 			end,
    -- 			desc = "Git Browse",
    -- 			mode = { "n", "v" },
    -- 		},
    -- 		{
    -- 			"<leader>gb",
    -- 			function()
    -- 				Snacks.git.blame_line()
    -- 			end,
    -- 			desc = "Git Blame Line",
    -- 		},
    -- 		{
    -- 			"<leader>gf",
    -- 			function()
    -- 				Snacks.lazygit.log_file()
    -- 			end,
    -- 			desc = "Lazygit Current File History",
    -- 		},
    -- 		{
    -- 			"<leader>gg",
    -- 			function()
    -- 				Snacks.lazygit()
    -- 			end,
    -- 			desc = "Lazygit",
    -- 		},
    -- 		{
    -- 			"<leader>gl",
    -- 			function()
    -- 				Snacks.lazygit.log()
    -- 			end,
    -- 			desc = "Lazygit Log (cwd)",
    -- 		},
    -- 		{
    -- 			"<leader>un",
    -- 			function()
    -- 				Snacks.notifier.hide()
    -- 			end,
    -- 			desc = "Dismiss All Notifications",
    -- 		},
    -- 		{
    -- 			"<c-/>",
    -- 			function()
    -- 				Snacks.terminal()
    -- 			end,
    -- 			desc = "Toggle Terminal",
    -- 		},
    -- 		{
    -- 			"<c-_>",
    -- 			function()
    -- 				Snacks.terminal()
    -- 			end,
    -- 			desc = "which_key_ignore",
    -- 		},
    -- 		{
    -- 			"]]",
    -- 			function()
    -- 				Snacks.words.jump(vim.v.count1)
    -- 			end,
    -- 			desc = "Next Reference",
    -- 			mode = { "n", "t" },
    -- 		},
    -- 		{
    -- 			"[[",
    -- 			function()
    -- 				Snacks.words.jump(-vim.v.count1)
    -- 			end,
    -- 			desc = "Prev Reference",
    -- 			mode = { "n", "t" },
    -- 		},
    -- 		{
    -- 			"<leader>N",
    -- 			desc = "Neovim News",
    -- 			function()
    -- 				Snacks.win({
    -- 					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
    -- 					width = 0.6,
    -- 					height = 0.6,
    -- 					wo = {
    -- 						spell = false,
    -- 						wrap = false,
    -- 						signcolumn = "yes",
    -- 						statuscolumn = " ",
    -- 						conceallevel = 3,
    -- 					},
    -- 				})
    -- 			end,
    -- 		},
    -- 	},
    -- 	init = function()
    -- 		vim.api.nvim_create_autocmd("User", {
    -- 			pattern = "VeryLazy",
    -- 			callback = function()
    -- 				-- Setup some globals for debugging (lazy-loaded)
    -- 				_G.dd = function(...)
    -- 					Snacks.debug.inspect(...)
    -- 				end
    -- 				_G.bt = function()
    -- 					Snacks.debug.backtrace()
    -- 				end
    -- 				vim.print = _G.dd -- Override print to use snacks for `:=` command
    --
    -- 				-- Create some toggle mappings
    -- 				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    -- 				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    -- 				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    -- 				Snacks.toggle.diagnostics():map("<leader>ud")
    -- 				Snacks.toggle.line_number():map("<leader>ul")
    -- 				Snacks.toggle
    -- 					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
    -- 					:map("<leader>uc")
    -- 				Snacks.toggle.treesitter():map("<leader>uT")
    -- 				Snacks.toggle
    -- 					.option("background", { off = "light", on = "dark", name = "Dark Background" })
    -- 					:map("<leader>ub")
    -- 				Snacks.toggle.inlay_hints():map("<leader>uh")
    -- 				Snacks.toggle.indent():map("<leader>ug")
    -- 				Snacks.toggle.dim():map("<leader>uD")
    -- 			end,
    -- 		})
    -- 	end,
    -- },
})

require("lsp")
-- require("winbar")
-- require("auto_cmd")

local map = vim.keymap.set

map("n", "ff", ":lua vim.lsp.buf.format()<CR>")
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")
map("i", "jk", "<ESC>")
-- map("n", "<leader>m", ":NvimTreeToggle<CR>")
-- map("n", "<leader>n", ":NvimTreeFocus<CR>")
map("n", "<leader>m", ":Neotree toggle<CR>")
map("n", "<esc>", ":noh<cr>")
map("n", "<M-right>", ":vertical resize +1<CR>")
map("n", "<M-left>", ":vertical resize -1<CR>")
map("n", "<M-Down>", ":resize +1<CR>")
map("n", "<M-Up>", ":resize -1<CR>")
map("n", "ee", "$")
map("n", "<space>h", "<c-w>h")

map("n", "<space>j", "<c-w>j")
map("n", "<space>k", "<c-w>k")
map("n", "<space>l", "<c-w>l")
map("n", "<C-a>", "ggVG")

map("n", "<C-k>", "<C-u>")
map("v", "<C-k>", "<C-u>")
map("n", "<C-j>", "<C-d>")
map("v", "<C-j>", "<C-d>")
map("n", "[b", ":bNext<CR>")
map("n", "]b", ":bnext<CR>")
map("n", "<leader>tn", ":tabnext<CR>")
map("n", "<leader>tp", ":tabprevious<CR>")
map("n", "<leader>ff", ":Telescope find_files<cr>")
map("n", "<leader><leader>f", ":Telescope live_grep<cr>")
map("n", "<leader>b", ":Telescope buffers<cr>")
-- map("n", "<leader>ff", ":FzfLua files<cr>")
-- map("n", "<leader><leader>f", ":FzfLua live_grep<cr>")
-- map("n", "<leader>b", ":FzfLua buffers<cr>")
map("v", "<leader>l", "$y<cr>")
map("n", "<leader>sc", ":source %<cr>")
map("t", "<C-x>", [[<C-\><C-n>]], { noremap = true, silent = true })
map("n", "<F3>", ":set spell! spell?<CR>", { noremap = true, silent = true })
map("n", "<leader>rq", ":cfdo %s///g | update | bd")
map("n", "<leader>te", ":sp | term<CR>", { noremap = true, silent = true })
map("n", "<leader>go", ":TSToolsOrganizeImports<CR>")
map("n", "<leader>gi", ":TSToolsAddMissingImports<CR>")
map("n", "<leader>cm", ":delmarks!<CR>")
map("n", "<leader><leader>w", ":HopAnywhere<cr>")
map("n", "<leader>bd", ":bd<cr>")
map("n", "<leader>ce", function()
    local diagnostic = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
    if #diagnostic > 0 then
        local msg = diagnostic[1].message
        vim.fn.setreg('+', msg)
        print("Copied diagnostic message to clipboard: " .. msg)
    else
        print("No diagnostic message found")
    end
end)
