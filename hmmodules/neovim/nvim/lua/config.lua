vim.bo.shiftwidth=4
vim.cmd.colorscheme "solarized8_flat"
vim.o.background = "dark"
vim.o.compatible = false
vim.o.cursorcolumn = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.number = true
vim.o.path = vim.o.path .. "**"
vim.o.smartindent = true
vim.o.tabstop=4
vim.keymap.set('n', 'eu', ':w<CR>', { noremap = true })
vim.keymap.set('n', 'eo', ':q<CR>', { noremap = true })
vim.cmd([[match ExtraWhitespace /\s\+$/]])
vim.cmd("highlight ExtraWhitespace ctermbg=red guibg=red")
