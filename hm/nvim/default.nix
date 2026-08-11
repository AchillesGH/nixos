{ pkgs, ... }:
{
  xdg.configFile = {
    "nvim/plugin".source = ./lua/plugin;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
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
    extraLuaConfig = builtins.readFile ./lua/init.lua;
  };

}
