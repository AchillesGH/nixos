{ pkgs, ... }:
{
  xdg.configFile = {
    #     "nvim/after".source = ./lua/after;
    "nvim/plugin".source = ./lua/plugin;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      nvim-tree-lua
      nvim-lspconfig
      blink-cmp
      fzf-lua
    ];
    extraPackages = with pkgs; [
      pyright
      rust-analyzer
      asm-lsp
    ];
    extraConfig = ''
      set number relativenumber
    '';
  };

}
