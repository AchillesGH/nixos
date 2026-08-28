local cmp = require("blink.cmp")
cmp.setup()
vim.schedule(function()
    vim.lsp.enable({
        "pyright",
        "clangd",
        "rust-analyzer",
        "asm-lsp",
    })
end)
