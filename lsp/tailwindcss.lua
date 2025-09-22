-- Install with: npm i -g @tailwindcss/language-server

---@type vim.lsp.Config
return {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
    },
    root_dir = vim.fs.dirname(
        vim.fs.find({ "tailwind.config.js", "tailwind.config.cjs", "tailwind.config.ts", "postcss.config.js", "package.json", ".git" }, { upward = true })[1]
    ),
    settings = {
        tailwindCSS = {
            lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidConfigPath = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
            },
            experimental = {
                classRegex = {
                    { "tw`([^`]*)", "([^`]*)" },
                    { 'tw="([^"]*)', '([^"]*)"' },
                    { "tw\\.\\w+`([^`]*)", "([^`]*)" },
                },
            },
        },
    },
}
