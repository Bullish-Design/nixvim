-- nvim/lua/plugins/starter.lua

local starter = require("mini.starter")

local items = {}

-- Sessions section (requires plugins/sessions.lua to be loaded first)
table.insert(items, { name = "Open session",   action = function() MiniSessions.select("read") end,   section = "Sessions" })
table.insert(items, { name = "Save session",   action = function() MiniSessions.select("write") end,  section = "Sessions" })
table.insert(items, { name = "Delete session", action = function() MiniSessions.select("delete") end, section = "Sessions" })

-- Recent + builtins
vim.list_extend(items, starter.sections.recent_files(8, true))
vim.list_extend(items, starter.sections.builtin_actions())

starter.setup({
  header = "Neovim",
  items = items,
  content_hooks = {
    starter.gen_hook.adding_bullet("• "),
    starter.gen_hook.aligning("center", "center"),
  },
})

-- Only show Starter when launching with no args AND no active session.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.v.this_session == "" then
      starter.open()
    end
  end,
})
