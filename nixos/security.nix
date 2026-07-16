{ pkgs, config, ... }:
{
  security.forcePageTableIsolation = true;
  security.pam.services.su.requireWheel = true;
  boot.kernelParams = [
    "slab_nomerge"
    "page_poison=1"
    "page_alloc.shuffle=1"
    "debugfs=off"
  ];
  boot.kexec.enable = false;
  environment.memoryAllocator.provider = "graphene-hardened-light";

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # recent vulner sources (dirty-frag family)
    "esp4"
    "esp6"
    "act_pedit"
    "rxrpc"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "befs"
    "bfs"
    "cifs"
    "cramfs"
    "efs"
    "exofs"
    "f2fs"
    "freevxfs"
    "gfs2"
    "hfs"
    "hfsplus"
    "hpfs"
    "jffs2"
    "jfs"
    "ksmbd"
    "minix"
    "nfs"
    "nfsv3"
    "nfsv4"
    "nilfs2"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "udf"
    "ufs"
    "vivid"

    "firewire-core" # Blocks FireWire DMA attacks
    "thunderbolt"
  ];

  boot.extraModprobeConfig = builtins.concatStringsSep "\n" (
    map (mod: "install ${mod} /bin/true") config.boot.blacklistedKernelModules
  );

  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.ftrace_enabled" = false;
    "kernel.sysrq" = 0;
    "kernel.io_uring_disabled" = 2;
    "kernel.yama.ptrace_scope" = 2;

    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    "net.ipv4.conf.all.log_martians" = true;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.log_martians" = true;
    "net.ipv4.conf.default.rp_filter" = 1;

    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
  };
  programs.ssh = {
    ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes256-ctr"
      "aes192-ctr"
      "aes128-gcm@openssh.com"
      "aes128-ctr"
    ];
    hostKeyAlgorithms = [
      "ssh-ed25519"
      "ssh-ed25519-cert-v01@openssh.com"
      "sk-ssh-ed25519@openssh.com"
      "sk-ssh-ed25519-cert-v01@openssh.com"
      "rsa-sha2-512"
      "rsa-sha2-512-cert-v01@openssh.com"
      "rsa-sha2-256"
      "rsa-sha2-256-cert-v01@openssh.com"
    ];
    kexAlgorithms = [
      "sntrup761x25519-sha512@openssh.com"
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
    ];
    macs = [
      "hmac-sha2-256-etm@openssh.com"
      "hmac-sha2-512-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
  };

  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [
    {
      users = [
        "achilles"
      ];
      keepEnv = false;
      persist = true;
      noPass = false;
    }
    {
      users = [ "confman" ];
      cmd = "sysrbb-cmd";
      keepEnv = false;
      noPass = true;
    }

    {
      users = [ "confman" ];
      cmd = "sysrbs-cmd";
      keepEnv = false;
      noPass = true;
    }

    {
      users = [ "confman" ];
      cmd = "nix-collect-garbage";
      args = [ "-d" ];
      keepEnv = false;
      noPass = true;
    }

    {
      users = [ "achilles" ];
      runAs = "prisoner";
      noPass = true;
      keepEnv = false;
    }
  ];

  fileSystems."/proc" = {
    device = "proc";
    fsType = "proc";
    options = [
      "rw"
      "nosuid"
      "nodev"
      "noexec"
      "relatime"
      "hidepid=2"
      "gid=${toString config.users.groups.wheel.gid}"
    ];
  };
}
