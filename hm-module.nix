{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;

    # Use your existing plugin list (derivations)
    plugins = import ./nvim/plugins.nix { inherit pkgs; };
  };

  # Deploy your whole config tree to ~/.config/nvim
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
