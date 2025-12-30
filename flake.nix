{
  description = "Neovim config as a Home Manager module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Pin mini.nvim source to a tag (or a commit/branch)
    mini-nvim-src = {
      url = "github:nvim-mini/mini.nvim/v0.17.0";
      flake = false;
    };
  };

  outputs = inputs@{ self, ... }: {
    homeManagerModules.default = import ./hm-module.nix { inherit inputs; };
  };
}
