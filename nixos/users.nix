{ pkgs, ... }:
{
  users.mutableUsers = false;
  users.users.root.hashedPassword = "!"; # Disable root login
  users.users.achilles = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
    ];
    hashedPassword = "$6$MZsrHPycaktj2oKS$dwZFry.WyrBjJ5cjwGJZTRS/Uf2HbyyZAI1DfAqIKCRsuz7d20Mm748c9ZgUfIGpqxVMc334Gj569YulUQY2z1";
  };
  users.users.confman = {
    isNormalUser = true;
    shell = pkgs.fish;
    home = "/home/confman";
    createHome = true;
    description = "System and user configuration manager";
    homeMode = "750";
    packages = with pkgs; [ kitty ];
    linger = true;
    hashedPassword = "$6$qtRqjATfokiJZ3J2$vNkJylh3LcbUifYaaGUEr0AO953c7FXUUO3L7eYBo3UpcRMnTSbGOW1OOrzP96ta02Uu3qsQ90kktvU64E6G2.";
  };

  environment.etc."security/access.conf".text = ''
    - : confman : ALL
    - : prisoner : ALL
  '';

  security.pam.services.login.rules.account.access = {
    order = 1000;
    control = "required";
    modulePath = "pam_access.so";
    args = [ "accessfile=/etc/security/access.conf" ];
  };
  security.pam.services.greetd.rules.account.access = {
    order = 1000;
    control = "required";
    modulePath = "pam_access.so";
    args = [ "accessfile=/etc/security/access.conf" ];
  };
  security.pam.services.sshd.rules.account.access = {
    order = 1000;
    control = "required";
    modulePath = "pam_access.so";
    args = [ "accessfile=/etc/security/access.conf" ];
  };

  users.users.prisoner = {
    isNormalUser = true;
    shell = pkgs.bash;
    hashedPassword = "!";
    extraGroups = [
    ];
  };

}
