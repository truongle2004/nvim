vim.loader.enable()

-- Leader key
vim.g.mapleader = " "

vim.g.python3_host_prog = "~/usr/bin/python3"

-- Basic settings
vim.o.completeopt = "menu,menuone,preview,noselect"
vim.o.sw = 4
vim.o.ts = 4
vim.o.et = true

-- UI settings
vim.wo.number = true
vim.o.mouse = "a"
vim.o.mousescroll = "ver:3,hor:0"
vim.o.linebreak = true
vim.o.winborder = "rounded"
vim.o.laststatus = 1
vim.o.cmdheight = 1
vim.o.showmode = false

-- Folding
vim.o.foldcolumn = "1"
vim.o.foldlevelstart = 99
vim.wo.foldtext = ""
vim.o.linespace = 2

-- Clipboard and undo
vim.o.clipboard = "unnamedplus"
vim.o.undofile = true

-- Search settings
vim.o.ignorecase = true
vim.o.smartcase = true

-- Sign column
vim.wo.signcolumn = "yes"

-- Timing
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10

-- Completion
vim.opt.wildignore:append({ ".DS_Store" })
vim.o.completeopt = "menuone,noselect,noinsert"
vim.o.pumheight = 15

-- Diff settings
vim.opt.diffopt:append("vertical,context:99")
vim.opt.shortmess:append({ w = true, s = true })

-- Cursor settings
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor"

-- Disable providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Neovide configuration
if vim.g.neovide then
    local map = vim.keymap.set
    map({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
    map({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
    map({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local map = vim.keymap.set

            lspconfig.html.setup({
                capabilities = capabilities,
            })

            lspconfig.cssls.setup({
                capabilities = capabilities,
            })

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            lspconfig.pylsp.setup({
                capabilities = capabilities,
                -- settings = {
                --     python = {
                --         venvPath = ".",
                --         venv = ".venv",
                --         analysis = {
                --             autoSearchPaths = true,
                --             useLibraryCodeForTypes = true
                --         }
                --     }
                -- }
            })

            -- Go LSP setup
            lspconfig.gopls.setup({
                capabilities = capabilities,
            })

            -- LSP keymaps
            map("n", "gD", vim.lsp.buf.declaration)
            map("n", "gd", vim.lsp.buf.definition)
            map("n", "K", vim.lsp.buf.hover)
            map("n", "gi", vim.lsp.buf.implementation)
            map("n", "ff", vim.lsp.buf.format)
            map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder)
            map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder)
            map("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end)
            map("n", "<leader>r", vim.lsp.buf.rename)
            map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action)
            map("n", "gr", vim.lsp.buf.references)
            map("n", "[e", function()
                vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
            end)
            map("n", "]e", function()
                vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
            end)
        end,
    },

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
                -- format_on_save = {
                -- 	timeout_ms = 500,
                -- 	lsp_format = "fallback",
                -- },
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
        "nvim-treesitter/nvim-treesitter",
        -- dependencies = {
        --   "HiPhish/rainbow-delimiters.nvim"
        -- },
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true,
                },
            })
        end,
    },
    {
        "nvim-tree/nvim-web-devicons",
        -- Lots of plugins will require this later.
        lazy = true,
        opts = {
            -- Make the icon for query files more visible.
            override = {
                scm = {
                    icon = "󰘧",
                    color = "#A9ABAC",
                    cterm_color = "16",
                    name = "Scheme",
                },
            },
        },
    },

    -- Rust support
    -- {
    --     "mrcjkb/rustaceanvim",
    --     ft = "rust",
    --     version = "^5",
    --     lazy = false,
    -- },

    -- Colorscheme
    -- {
    --     "wincent/base16-nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd([[colorscheme gruvbox-dark-hard]])
    --         vim.o.background = 'dark'
    --
    --         -- Customize highlighting
    --         local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
    --         vim.api.nvim_set_hl(0, 'Comment', bools)
    --
    --         local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
    --         vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', {
    --             fg = marked.fg,
    --             bg = marked.bg,
    --             ctermfg = marked.ctermfg,
    --             ctermbg = marked.ctermbg,
    --             bold = true
    --         })
    --     end
    -- },

    -- Inline diagnostics
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup()
        end,
    },

    -- Mason lsp
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "lua-language-server",
                "rust-analyzer",
            }
        }
    },

    -- Tabline
    {
        'echasnovski/mini.tabline',
        version = '*',
        config = function()
            require("mini.tabline").setup()
        end
    },

    {
        "craftzdog/solarized-osaka.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            require("solarized-osaka").setup({
                background_style = "dark",
                transparent = false
            })
            vim.cmd([[colorscheme solarized-osaka]])
        end
    },

    -- Fuzzy finder
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        config = function()
            require("fzf-lua").setup {
                file_ignore_patterns = {
                    "node_modules/",
                    "dist/",
                    ".next/",
                    ".git",
                    ".gitlab/",
                    "build/",
                    "target/",
                    "package-lock.json",
                    "pnpm-lock.yaml",
                    "yarn.lock",
                    "venv",
                    "__pycache__",


                },

            }
        end
    },

    {
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
    },

    -- Go support
    {
        "ray-x/go.nvim",
        ft = { "go", "gomod" },
        dependencies = { "ray-x/guihua.lua" },
        event = { "CmdlineEnter" },
        build = ':lua require("go.install").update_all_sync()',
        config = function()
            require("go").setup({})

            -- Auto-format on save
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

    {
        "Exafunction/windsurf.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("codeium").setup({
                virtual_text = {
                    enabled = true,
                }

            })
        end
    },

    -- Auto-completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspConfig = require("lspconfig")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                experimental = {
                    ghost_text = true,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                },
            })

            -- Snippet keymaps
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
        'echasnovski/mini.pairs',
        version = '*',
        config = function()
            require("mini.pairs").setup()
        end

    },
    {
        'echasnovski/mini.surround',
        version = '*',
        config = function()
            require("mini.surround").setup()
        end
    },

    -- File explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
    },

    -- LSP signature help
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        config = function()
            require("lsp_signature").setup({
                doc_lines = 0,
                handler_opts = {
                    border = "none",
                },
            })
        end,
    },
}, {
    rocks = {
        enabled = false,
    },
    performance = {
        rpt = {
            disabled_plugins = {
                "netrwPlugin",
                "rplugin",
                "tarPlugin",
                "tohtml",
                "tutor",
            }
        }
    }
})



-- Autocommands
local function create_autocmds()
    -- Set tab settings for all files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        command = "setlocal tabstop=4 shiftwidth=4 softtabstop=4",
    })

    -- Big file handling
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("mariasolos/big_file", { clear = true }),
        desc = "Disable features in big files",
        pattern = "bigfile",
        callback = function(args)
            vim.schedule(function()
                vim.bo[args.buf].syntax = vim.filetype.match({ buf = args.buf }) or ""
            end)
        end,
    })

    -- Close with q for certain filetypes
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("mariasolos/close_with_q", { clear = true }),
        desc = "Close with <q>",
        pattern = { "git", "help", "man", "qf", "query", "scratch" },
        callback = function(args)
            vim.keymap.set("n", "q", "<cmd>quit<cr>", { buffer = args.buf })
        end,
    })

    -- Dotfiles setup
    vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("mariasolos/dotfiles_setup", { clear = true }),
        desc = "Special dotfiles setup",
        callback = function()
            local ok, inside_dotfiles = pcall(vim.startswith, vim.fn.getcwd(), vim.env.XDG_CONFIG_HOME)
            if not ok or not inside_dotfiles then
                return
            end

            vim.env.GIT_WORK_TREE = vim.env.HOME
            vim.env.GIT_DIR = vim.env.HOME .. "/.cfg"
        end,
    })

    -- Command window enhancement
    vim.api.nvim_create_autocmd("CmdwinEnter", {
        group = vim.api.nvim_create_augroup("mariasolos/execute_cmd_and_stay", { clear = true }),
        desc = "Execute command and stay in the command-line window",
        callback = function(args)
            vim.keymap.set({ "n", "i" }, "<S-CR>", "<cr>q:", { buffer = args.buf })
        end,
    })

    -- Remember last position
    vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("mariasolos/last_location", { clear = true }),
        desc = "Go to the last location when opening a buffer",
        callback = function(args)
            local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
            local line_count = vim.api.nvim_buf_line_count(args.buf)
            if mark[1] > 0 and mark[1] <= line_count then
                vim.cmd('normal! g`"zz')
            end
        end,
    })

    -- Line number toggling
    local line_numbers_group = vim.api.nvim_create_augroup("mariasolos/toggle_line_numbers", {})
    vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
        group = line_numbers_group,
        desc = "Toggle relative line numbers on",
        callback = function()
            if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, "i") then
                vim.wo.relativenumber = true
            end
        end,
    })

    vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
        group = line_numbers_group,
        desc = "Toggle relative line numbers off",
        callback = function(args)
            if vim.wo.nu then
                vim.wo.relativenumber = false
            end

            if args.event == "CmdlineEnter" then
                if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then
                    vim.cmd.redraw()
                end
            end
        end,
    })

    -- Write to ShaDa on buffer delete
    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        group = vim.api.nvim_create_augroup("mariasolos/wshada_on_buf_delete", { clear = true }),
        desc = "Write to ShaDa when deleting/wiping out buffers",
        command = "wshada",
    })

    -- Highlight on yank
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = vim.api.nvim_create_augroup("mariasolos/yank_highlight", { clear = true }),
        desc = "Highlight on yank",
        callback = function()
            vim.hl.on_yank({ higroup = "Visual", priority = 250 })
        end,
    })
end

create_autocmds()

-- Key mappings
local function setup_keymaps()
    local map = vim.keymap.set

    -- Basic mappings
    map("n", ";", ":", { desc = "CMD enter command mode" })
    map("i", "jj", "<ESC>")
    map("i", "jk", "<ESC>")

    -- File explorer
    map("n", "<leader>e", ":Neotree toggle<CR>")
    map("n", "<leader>n", ":Neotree reveal<cr>")

    -- Fuzzy finder
    map("n", "<leader>ff", ":FzfLua files<CR>")
    map("n", "<leader>fg", ":FzfLua live_grep<CR>")

    -- Clear search highlight
    map("n", "<esc>", ":noh<cr>")

    -- Window resizing
    map("n", "<M-right>", ":vertical resize +1<CR>")
    map("n", "<M-left>", ":vertical resize -1<CR>")
    map("n", "<M-Down>", ":resize +1<CR>")
    map("n", "<M-Up>", ":resize -1<CR>")

    -- Navigation
    map("n", "ee", "$")
    map("n", "<space>h", "<c-w>h")
    map("n", "<space>j", "<c-w>j")
    map("n", "<space>k", "<c-w>k")
    map("n", "<space>l", "<c-w>l")

    -- Select all
    map("n", "<C-a>", "ggVG")

    -- Scroll
    map("n", "<C-k>", "<C-u>")
    map("v", "<C-k>", "<C-u>")
    map("n", "<C-j>", "<C-d>")
    map("v", "<C-j>", "<C-d>")

    -- Buffer navigation
    map("n", "[b", ":bNext<CR>")
    map("n", "]b", ":bnext<CR>")
    map("n", "<leader>bd", ":bd<cr>")

    -- Tab navigation
    map("n", "<leader>tn", ":tabnext<CR>")
    map("n", "<leader>tp", ":tabprevious<CR>")

    -- Utility
    map("v", "<leader>l", "$y<cr>")
    map("n", "<leader>sc", ":source %<cr>")
    map("n", "<leader>rs", ":source ~/.config/nvim/init.lua<cr>")
    map("t", "<C-x>", [[<C-\><C-n>]], { noremap = true, silent = true })
    map("n", "<F3>", ":set spell! spell?<CR>", { noremap = true, silent = true })
    map("n", "<leader>rq", ":cfdo %s///g | update | bd")
    map("n", "<leader>te", ":sp | term<CR>", { noremap = true, silent = true })
    map("n", "<leader>go", ":TSToolsOrganizeImports<CR>")
    map("n", "<leader>gi", ":TSToolsAddMissingImports<CR>")
    map("n", "<leader>cm", ":delmarks!<CR>")

    -- Copy diagnostic message
    map("n", "<leader>ce", function()
        local diagnostic = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
        if #diagnostic > 0 then
            local msg = diagnostic[1].message
            vim.fn.setreg("+", msg)
            print("Copied diagnostic message to clipboard: " .. msg)
            print(msg)
        else
            print("No diagnostic message found")
        end
    end)
end

setup_keymaps()
