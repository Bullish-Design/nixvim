{
  description = "Custom Neovim config for use with NixOS";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
  {
    homeManagerModules.default = import ./hm-module.nix;
  };
}
