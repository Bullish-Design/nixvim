-- ~/.config/nvim/lua/plugins/telescope.lua

local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
    file_ignore_patterns = { "node_modules", ".git/" },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
})

telescope.load_extension("fzf")

vim.keymap.set("n", "<leader>tf", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>tg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>tb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>th", builtin.help_tags, { desc = "Telescope help tags" })
