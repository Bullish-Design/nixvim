-- nvim/lua/plugins/starter.lua

local starter = require("mini.starter")

starter.setup({
  header = "Neovim",

  items = function()
    local items = {
      { name = "Open session",   action = function() MiniSessions.select("read") end,   section = "Sessions" },
      { name = "Save session",   action = function() MiniSessions.select("write") end,  section = "Sessions" },
      { name = "Delete session", action = function() MiniSessions.select("delete") end, section = "Sessions" },
    }

    vim.list_extend(items, starter.sections.recent_files(8, true))
    vim.list_extend(items, starter.sections.builtin_actions())
    return items
  end,

  content_hooks = {
    starter.gen_hook.adding_bullet("• "),
    starter.gen_hook.aligning("center", "center"),
  },
})

-- Show Starter only when launching with no args and no active session.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.v.this_session == "" then
      starter.open()
    end
  end,
})
