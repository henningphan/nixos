-- Run command CopilotModels to list models and see github copilot settings to see which are activated.
require('CopilotChat').setup({
  model = 'gpt-5.5',
})

vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", {
  desc = "Toggle Copilot Chat",
})
