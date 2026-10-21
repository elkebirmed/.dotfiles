local augroup = vim.api.nvim_create_augroup("dotfiles_nvim", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.highlight.on_yank()
    end,
    desc = "Highlight yanked text",
})

vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    callback = function()
        local ok, lint = pcall(require, "lint")
        if ok then
            lint.try_lint()
        end
    end,
    desc = "Lint modified file on save",
})
