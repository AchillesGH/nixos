{ ... }: {
  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "achilles" ];

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;
}
