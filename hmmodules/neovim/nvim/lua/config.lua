vim.bo.shiftwidth=2
vim.cmd.colorscheme "solarized8_flat"
vim.o.background = "dark"
vim.o.compatible = false
vim.o.cursorcolumn = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.number = true
vim.o.path = vim.o.path .. "**"
vim.o.smartindent = true
vim.o.softtabstop = 2
vim.o.tabstop=2
vim.keymap.set('n', 'eu', ':w<CR>', { noremap = true })
vim.keymap.set('n', 'eo', ':q<CR>', { noremap = true })
vim.cmd([[match ExtraWhitespace /\s\+$/]])
vim.cmd("highlight ExtraWhitespace ctermbg=red guibg=red")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle("diagnostics") end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

vim.o.foldnestmax=1
vim.wo.foldenable = false
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo.foldmethod = 'expr'

vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

vim.cmd([[
  augroup filetypedetect
    autocmd! BufRead,BufNewFile *.bzl set filetype=python
    autocmd! BufRead,BufNewFile *.bazel set filetype=python
  augroup END
]])

