require('nvim-treesitter.config').setup({
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<Leader>ss",
      node_incremental = "<Leader>si",
      scope_incremental = "<Leader>sc",
      node_decremental = "<Leader>sd",
    },
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})
