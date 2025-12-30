-- nvim/lua/plugins/starter.lua

local starter = require("mini.starter")

starter.setup({
  header = "Neovim",
  autoopen = false,
  evaluate_single = true,

  -- NOTE: items MUST be a table/array. Elements can be items/arrays/functions.
  items = {
    -- Works with mini.sessions (loads list + actions)
    starter.sections.sessions(5, true),

    starter.sections.recent_files(8, true),
    starter.sections.builtin_actions(),

    -- Optional: a simple custom action
    { name = "New file", action = "enew", section = "Builtin actions" },
  },

  content_hooks = {
    starter.gen_hook.adding_bullet("• "),
    starter.gen_hook.aligning("center", "center"),
  },
})

-- Open Starter only when launching empty and no session is active
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.v.this_session == "" then
      starter.open()
    end
  end,
})
