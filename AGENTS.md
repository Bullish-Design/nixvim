# AGENTS.md

## Repository Overview

**Repository**: `nixvim`  
**Purpose**: Neovim configuration packaged as a Home Manager module for NixOS  
**Architecture**: Flake-based, modular Lua configuration with Nix package management  
**Dependencies**: Part of the Bullish-Design NixOS ecosystem (nix-meta, nix-terminal, nixos-core)

## Core Architecture

### Flake Structure

```
flake.nix
├─ inputs
│  ├─ nixpkgs (nixos-unstable)
│  └─ mini-nvim-src (pinned tarball, flake=false)
└─ outputs
   └─ homeManagerModules.default → hm-module.nix
```

**Key Design**: mini.nvim is pinned via flake input to avoid version drift while other plugins come from nixpkgs.

### Home Manager Module (hm-module.nix)

**Responsibilities**:
1. Build pinned mini.nvim as Vim plugin
2. Import plugin list from `nvim/plugins.nix`
3. Filter out nixpkgs mini.nvim to avoid duplicates
4. Enable neovim with vim/vi aliases
5. Deploy entire `nvim/` directory to `~/.config/nvim`
6. Include LSP servers and search tools in home.packages

**Plugin Merge Logic**:
```nix
plugins = [ mini-nvim ] ++ builtins.filter (p: !(builtins.match "mini.*" n != null)) pluginsFromRepo
```

This ensures only the pinned mini.nvim is used, not the nixpkgs version.

### Neovim Configuration Structure

```
nvim/
├─ init.lua                  # Entry point: sets leader, requires config & plugins
├─ lua/
│  ├─ config/
│  │  ├─ init.lua            # Loads options and keymaps
│  │  ├─ options.lua         # UI, editing, listchars, floating windows
│  │  └─ keymaps.lua         # Core keybinds, mini.pick, diagnostics
│  ├─ plugins/
│  │  ├─ init.lua            # Requires all plugin configs
│  │  ├─ mini.lua            # mini.nvim suite setup (theme, files, ai, statusline, etc.)
│  │  ├─ lsp.lua             # LSP config using vim.lsp.config/enable (0.11+ API)
│  │  ├─ codecompanion.lua   # AI coding assistant setup
│  │  ├─ telescope.lua       # Fuzzy finder with fzf extension
│  │  ├─ sessions.lua        # mini.sessions for session management
│  │  └─ starter.lua         # mini.starter dashboard with custom sections
│  └─ ui/
│     └─ header.lua          # ASCII art for starter screen
└─ plugins.nix               # Nix derivations for Vim plugins
```

## Plugin Inventory

### From mini.nvim (all configured in mini.lua)
- `mini.hues` - Generated colorscheme (background: #0f1115, accent: azure)
- `mini.files` - File explorer
- `mini.ai` - Enhanced text objects
- `mini.comment` - Smart commenting
- `mini.surround` - Surround operations
- `mini.pairs` - Auto-pairs
- `mini.statusline` - Status bar
- `mini.tabline` - Tab/buffer line
- `mini.indentscope` - Indent guides with scope highlighting
- `mini.cursorword` - Highlight word under cursor
- `mini.pick` - Fuzzy picker (integrates with rg/fd)
- `mini.completion` - Minimal completion
- `mini.notify` - Better notifications
- `mini.sessions` - Session management
- `mini.starter` - Start screen

### From nixpkgs (plugins.nix)
- `nvim-lspconfig` - LSP configuration helper
- `plenary.nvim` - Lua utility library
- `telescope.nvim` - Fuzzy finder
- `telescope-fzf-native.nvim` - FZF sorter for Telescope
- `nvim-treesitter` - Syntax tree parser

### Custom Built
- `codecompanion.nvim` - Fetched from GitHub (olimorris/codecompanion.nvim)

## Language Server Configuration

**Current LSP Servers** (installed via home.packages):
- `lua-language-server` → lua_ls (config: ignore third-party warnings, recognize vim global)
- `nil` → nil_ls (Nix LSP)
- `bash-language-server` → bashls

**LSP Setup Pattern** (Neovim 0.11+):
```lua
vim.lsp.config("server_name", { on_attach = on_attach, settings = {...} })
vim.lsp.enable("server_name")
```

**Common on_attach keybinds**:
- `gd` - Go to definition
- `gr` - References
- `K` - Hover
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `<leader>f` - Format

**Diagnostics config**:
- Virtual text disabled (use float instead)
- Rounded borders on float windows
- Severity sorting enabled

## Keymap Conventions

**Leader**: `<Space>`

### Core Bindings (keymaps.lua)
- `<leader>w` - Write file
- `<leader>q` - Quit
- `<leader>h` - Clear search highlight

### File/Search (mini.pick)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Buffers

### Telescope (telescope.lua)
- `<leader>tf` - Telescope find files
- `<leader>tg` - Telescope live grep
- `<leader>tb` - Telescope buffers
- `<leader>th` - Telescope help tags

### Diagnostics
- `<leader>e` - Open diagnostic float
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

### CodeCompanion
- `<leader>cc` - Open CodeCompanion chat
- `<leader>ca` - CodeCompanion actions
- `<leader>ct` - Toggle CodeCompanion

## Configuration Patterns

### Option Setting
Use `vim.opt` for options:
```lua
vim.opt.number = true
vim.opt.relativenumber = true
```

### Keymap Registration
Use `vim.keymap.set` with description:
```lua
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write" })
```

### Plugin Setup
Call `require("plugin").setup({...})` in plugin-specific files:
```lua
require("mini.files").setup()
require("telescope").setup({ defaults = {...} })
```

## Ecosystem Integration

### As Home Manager Module
```nix
{ inputs, ... }: {
  imports = [ inputs.nixvim.homeManagerModules.default ];
}
```

### In nix-terminal Context
The nix-terminal flake imports nixvim and makes it available:
```nix
# nix-terminal/modules/terminal.nix
imports = [ nixvim.homeManagerModules.default ];
```

### In nix-meta Context
Used in developer profile:
```nix
# nix-meta/profiles/developer.nix
users.nixos = {
  imports = [ nix-terminal.homeManagerModules.terminal ];
}
```

## Refactoring Opportunities

### High Priority

1. **Modularize LSP Configurations**
   - Split lsp.lua into per-language files (lua/lsp/lua.lua, lua/lsp/nix.lua, etc.)
   - Create lsp/common.lua for shared on_attach and diagnostic config
   - Add more language servers (Python, JavaScript, Rust, etc.)

2. **Expand Plugin Coverage**
   - Add treesitter-textobjects for better text navigation
   - Add nvim-cmp or expand mini.completion with sources
   - Add gitsigns or mini.diff for git integration
   - Add which-key or mini.clue for keymap discovery

3. **Session Workflow Enhancement**
   - Add project detection (via git root or other markers)
   - Auto-create sessions per project
   - Add session templates (similar to tmuxp templates in nix-terminal)

4. **Starter Screen Customization**
   - Add recent projects (not just files)
   - Add git status for recent items
   - Add custom action for common workflows

### Medium Priority

5. **CodeCompanion Configuration**
   - Add more adapters (OpenAI, local models)
   - Create custom strategies for common tasks
   - Add project-specific prompts

6. **Telescope Enhancement**
   - Add more pickers (git commits, LSP symbols, etc.)
   - Integrate with project detection
   - Add custom file sorters

7. **Keybind Organization**
   - Create which-key groups for related commands
   - Document all keybinds in a central location
   - Add leader key guide overlay

8. **Theme Customization**
   - Make mini.hues colors configurable via Nix options
   - Add alternate colorscheme options
   - Create light/dark theme toggle

### Low Priority

9. **Testing Infrastructure**
   - Add lua tests for configuration functions
   - Add integration tests for plugin setups
   - Create CI workflow for linting

10. **Documentation**
    - Add inline documentation for complex configs
    - Create user guide for common workflows
    - Document all available keybinds in README

## Nix Conventions

### Plugin Declaration Pattern
```nix
{ pkgs }:
let
  vp = pkgs.vimPlugins;
  custom-plugin = pkgs.vimUtils.buildVimPlugin {
    pname = "plugin-name";
    version = "unstable";
    src = pkgs.fetchFromGitHub { ... };
  };
in [ vp.existing-plugin custom-plugin ]
```

### Flake Input Pinning
For stable plugins, pin specific versions:
```nix
inputs.plugin-src = {
  url = "tarball+https://github.com/owner/repo/archive/refs/tags/vX.Y.Z.tar.gz";
  flake = false;
};
```

### Version Updates
When updating pinned plugins:
1. Update URL in flake.nix
2. Run `nix flake update`
3. Update sha256 if manually fetched
4. Test plugin functionality

## Code Style Guidelines

### Lua
- 2-space indentation
- Keep lines under 120 characters
- Use descriptive variable names
- Group related configurations
- Add comments for non-obvious configs
- Use local functions where possible

### Nix
- 2-space indentation
- Use `let...in` for readability
- Keep expressions under 120 characters
- Use `inherit` for clarity
- Comment complex derivations

## Testing Checklist

When adding/modifying features:

- [ ] Test in fresh Home Manager build
- [ ] Verify all keybinds work
- [ ] Check LSP functionality for affected languages
- [ ] Ensure no plugin conflicts
- [ ] Test session save/restore
- [ ] Verify starter screen renders correctly
- [ ] Check integration with nix-terminal if applicable

## Common Pitfalls

1. **Plugin Duplication**: Always filter out nixpkgs versions of manually-built plugins
2. **LSP API Changes**: This config uses Neovim 0.11+ API (vim.lsp.config/enable)
3. **Mini.nvim Version**: Ensure pinned version matches required features
4. **Keymap Conflicts**: Check existing binds before adding new ones
5. **Session Path Issues**: Sessions are stored in `~/.local/share/nvim/sessions`

## Extension Points

### Adding New LSP Server
1. Add server package to `home.packages` in hm-module.nix
2. Add config in lsp.lua:
   ```lua
   vim.lsp.config("server_name", { on_attach = on_attach })
   vim.lsp.enable("server_name")
   ```

### Adding New Plugin
1. Add to plugins.nix (or build custom if not in nixpkgs)
2. Create config file in lua/plugins/
3. Require in lua/plugins/init.lua
4. Add keybinds in relevant location

### Adding New Mini Module
1. Add setup call in mini.lua
2. Configure options as needed
3. Add keybinds if applicable

## Dependencies on Other Repos

### nix-terminal
- Provides terminal environment where nvim runs
- Includes scripts that may interact with nvim sessions
- Tmux integration for multi-pane workflows

### devman
- Development tools available in shell
- May provide language runtimes used by LSP servers

### nixos-core
- System-level Nix configuration
- Provides base packages and settings

## Future Considerations

1. **Workspace Support**: Add per-project configurations
2. **DAP Integration**: Add debugging support via nvim-dap
3. **Testing Framework**: Add test runner integration
4. **AI Enhancements**: Expand CodeCompanion or add alternatives
5. **Performance Optimization**: Profile startup time and optimize
6. **Cross-Platform**: Ensure works on non-NixOS systems with Nix
