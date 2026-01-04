# nixvim
A Neovim configuration for use with NixOS, Home-Manager, and Flakes

## Additional Plugins

### Telescope
Telescope provides fuzzy finding across files, buffers, and more.

Keybindings:
- `<leader>ff` find files
- `<leader>fg` live grep
- `<leader>fb` list buffers

### CodeCompanion
CodeCompanion adds AI-assisted coding workflows directly in Neovim.

Keybindings:
- `<leader>cc` open CodeCompanion
- `<leader>cn` start a new CodeCompanion chat
- `<leader>cs` toggle CodeCompanion sidebar

Note: set the `ANTHROPIC_API_KEY` environment variable to enable CodeCompanion's Anthropic integration.
