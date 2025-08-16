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

function live_grep_from_project_git_root()
	local function is_git_repo()
		vim.fn.system("git rev-parse --is-inside-work-tree")

		return vim.v.shell_error == 0
	end

	local function get_git_root()
		local dot_git_path = vim.fn.finddir(".git", ".;")
		return vim.fn.fnamemodify(dot_git_path, ":h")
	end

	local opts = {}

	if is_git_repo() then
		opts = {
			cwd = get_git_root(),
		}
	end

	require("telescope.builtin").live_grep(opts)
end
function vim.find_files_from_project_git_root()
  local function is_git_repo()
    vim.fn.system("git rev-parse --is-inside-work-tree")
    return vim.v.shell_error == 0
  end
  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end
  local opts = {}
  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end
  require("telescope.builtin").find_files(opts)
end
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', vim.find_files_from_project_git_root, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', live_grep_from_project_git_root, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false
      },
    },
  }
}

vim.cmd([[
  augroup filetypedetect
    autocmd! BufRead,BufNewFile *.bzl set filetype=python
    autocmd! BufRead,BufNewFile *.bazel set filetype=python
  augroup END
]])

