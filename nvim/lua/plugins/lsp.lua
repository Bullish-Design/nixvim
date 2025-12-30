local lspconfig = require("lspconfig")

-- Basic LSP UX (builtin)
vim.diagnostic.config({
  virtual_text = false,
  float = { border = "rounded" },
  severity_sort = true,
})

local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
end

-- Servers (install via Nix: lua-language-server, nil, bash-language-server)
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
})

lspconfig.nil_ls.setup({ on_attach = on_attach })
lspconfig.bashls.setup({ on_attach = on_attach })
