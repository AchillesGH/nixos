{
  pkgs,
  lib,
  ...
}: {
  imports = [../../shared/helix];
  programs.helix.languages.language = [
    {
      name = "c";
      auto-format = true;
      formatter.command = lib.getExe' pkgs.clang-tools "clang-format";
    }
  ];
}
