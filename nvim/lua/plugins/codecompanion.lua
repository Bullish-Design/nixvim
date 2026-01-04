require("codecompanion").setup({
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = "ANTHROPIC_API_KEY",
        },
      })
    end,
  },
  display = {
    chat = {
      window = {
        layout = "float",
      },
    },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanion chat" })
vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion actions" })
vim.keymap.set("n", "<leader>ct", "<cmd>CodeCompanionToggle<cr>", { desc = "CodeCompanion toggle" })
