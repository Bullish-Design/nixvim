<<<<<<< HEAD
-- nvim/lua/plugins/codecompanion.lua

-- Warn if API keys are missing
local function check_api_key(env_var, name)
  if os.getenv(env_var) == nil then
    vim.notify(name .. " API key not found. Set " .. env_var .. " environment variable.", vim.log.levels.WARN)
  end
end
check_api_key("ANTHROPIC_API_KEY", "Anthropic")
check_api_key("OPENAI_API_KEY", "OpenAI")

local ok, codecompanion = pcall(require, "codecompanion")
if not ok then
  vim.notify("codecompanion.nvim not available", vim.log.levels.WARN)
  return
end

codecompanion.setup({
  adapters = {
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = os.getenv("ANTHROPIC_API_KEY") or "",
        },
      })
    end,
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        env = {
          api_key = os.getenv("OPENAI_API_KEY") or "",
        },
      })
    end,
  },
  display = {
    action_palette = {
      width = 95,
      height = 10,
    },
    chat = {
      window = {
        layout = "vertical",
        border = "single",
        height = 0.8,
        width = 0.45,
        relative = "editor",
      },
    },
  },
  strategies = {
    chat = {
      adapter = "anthropic",
    },
    inline = {
      adapter = "openai",
    },
  },
})

-- Keybindings
local map = vim.keymap.set

map("n", "<leader>ai", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion actions" })
map("n", "<leader>aa", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanion chat" })
map("v", "<leader>aa", "<cmd>CodeCompanionChat<cr>", { desc = "CodeCompanion chat" })
map("n", "<leader>at", "<cmd>CodeCompanionToggle<cr>", { desc = "CodeCompanion toggle" })
||||||| 4ce0011
=======
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
>>>>>>> f723d6dc1a9be27911a97b8d28b7a251c6059483
