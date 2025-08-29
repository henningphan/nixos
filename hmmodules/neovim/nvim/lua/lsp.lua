local format_on_close = function()
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    callback = function() vim.lsp.buf.format { async = false } end
  })
end

-- See link for examples and config:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local servers = {
  --dockerls={},
  ansiblels = {},
  bashls = {},
  gopls = {},
  helm_ls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' } }
      }
    }
  },
  marksman = {},
  nil_ls = {},
  pyright = {},
  terraformls = {},
  yamlls = {},
}

vim.lsp.config['*'] = { on_attach = format_on_close }

for lsp, conf in pairs(servers) do
  vim.lsp.config[lsp] = conf
  vim.lsp.enable(lsp)
end
