local nvim_lsp = require('lspconfig')

local format_on_close = function()
  vim.api.nvim_create_autocmd({"BufWritePre"}, {
      callback = function()vim.lsp.buf.format { async = false }end
  })
end

-- See:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  lua_ls={
    settings = {
      Lua = {
        diagnostics = {
	  globals = { 'vim' }
	}
      }
    }
  },
  helm_ls={},
  nil_ls={},
  eslint={},
  gopls={
    on_attach=format_on_close
  },
  pyright={},
  bashls={},
  --dockerls={},
  clangd={},
  terraformls={_on_attach=function()
	  vim.api.nvim_create_autocmd({"BufWritePre"}, {
	      pattern = {"*.tf", "*.tfvars"},
	      callback = vim.lsp.buf.formatting_sync
	  })
      end
  },
}

for lsp, conf in pairs(servers) do
  conf['flags'] = {
      debounce_text_changes = 150,
  }
  nvim_lsp[lsp].setup(conf)
end
