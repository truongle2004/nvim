-- Install with: npm i -g typescript typescript-language-server

---@type vim.lsp.Config
return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    root_dir = vim.fs.dirname(
        vim.fs.find({ "tsconfig.json", "package.json", ".git" }, { upward = true })[1]
    ),
    settings = {
        completions = {
            completeFunctionCalls = true,
        },
    },
}
