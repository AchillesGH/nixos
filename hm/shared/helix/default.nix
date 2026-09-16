{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [lua-language-server nixd bash-language-server fish-lsp marksman];
    settings = {
      editor = {
        indent-guides = {
          render = true;
        };
        lsp.display-progress-messages = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.alejandra;
      }
    ];
  };
}
