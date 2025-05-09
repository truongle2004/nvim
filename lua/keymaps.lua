---@diagnostic disable: undefined-global

local map = vim.keymap.set

-- map("n", "ff", ":lua vim.lsp.buf.format()<CR>")
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")
map("i", "jk", "<ESC>")
map("n", "<leader>e", ":Neotree toggle<CR>")
map("n", "<leader>ff", ":FzfLua files<CR>")
map("n", "<leader>fg", ":FzfLua live_grep<CR>")
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
map("v", "<leader>l", "$y<cr>")
map("n", "<leader>sc", ":source %<cr>")
map("t", "<C-x>", [[<C-\><C-n>]], { noremap = true, silent = true })
map("n", "<F3>", ":set spell! spell?<CR>", { noremap = true, silent = true })
map("n", "<leader>rq", ":cfdo %s///g | update | bd")
map("n", "<leader>te", ":sp | term<CR>", { noremap = true, silent = true })
map("n", "<leader>go", ":TSToolsOrganizeImports<CR>")
map("n", "<leader>gi", ":TSToolsAddMissingImports<CR>")
map("n", "<leader>cm", ":delmarks!<CR>")
map("n", "<leader>bd", ":bd<cr>")
map("n", "<leader>rs", ":source ~/.config/nvim/init.lua<cr>")
map("n", "<leader>ce", function()
	local diagnostic = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostic > 0 then
		local msg = diagnostic[1].message
		vim.fn.setreg("+", msg)
		print("Copied diagnostic message to clipboard: " .. msg)
	else
		print("No diagnostic message found")
	end
end)
map("n", "<leader>n", ":Neotree reveal<cr>")

