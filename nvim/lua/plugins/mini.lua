-- mini.nvim is one plugin with many modules
require("mini.ai").setup()
require("mini.comment").setup()
require("mini.surround").setup()

-- Lightweight statusline + indentation guides + pairs
require("mini.statusline").setup()
require("mini.indentscope").setup({ symbol = "│" })
require("mini.pairs").setup()

-- Picker using builtin tools (rg/fd help a lot)
require("mini.pick").setup()

-- Minimal completion (built-in LSP + mini completion)
require("mini.completion").setup()
