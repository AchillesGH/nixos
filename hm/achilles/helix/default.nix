{
  pkgs,
  lib,
  ...
}: {
  imports = [../../shared/helix];
  programs.helix = {
    extraPackages = with pkgs; [ruff vscode-langservers-extracted matlab-language-server clang-tools asm-lsp gopls];
    languages.language = [
      {
        name = "c";
        auto-format = true;
        formatter.command = lib.getExe' pkgs.clang-tools "clang-format";
      }
    ];
  };
}
