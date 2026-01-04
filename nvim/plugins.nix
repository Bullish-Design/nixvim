{ pkgs }:
let
  vp = pkgs.vimPlugins;
  codecompanion-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "codecompanion.nvim";
    version = "unstable";
    src = pkgs.fetchFromGitHub {
      owner = "olimorris";
      repo = "codecompanion.nvim";
      rev = "main";
      sha256 = "sha256-L4G1vZJKsLzQpJkbUod3Zrrp4lndplQIVfF4YukmYjE=";
    };
  };
in [
  # Small, batteries-included Lua plugin suite
  vp.mini-nvim

  # Light LSP configuration helper
  vp.nvim-lspconfig

  vp.plenary-nvim
  vp.telescope-nvim
  vp.telescope-fzf-native-nvim
  vp.nvim-treesitter
  codecompanion-nvim
]
