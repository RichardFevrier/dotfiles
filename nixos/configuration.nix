{
  config,
  pkgs,
  inputs,
  ...
}:

let
  flatpaks = ''
    app.fotema.Fotema
    codes.loers.Karlender
    com.bitwarden.desktop
    com.dropbox.Client
    com.github.PintaProject.Pinta
    com.github.tchx84.Flatseal
    com.github.wwmm.easyeffects
    com.vscodium.codium
    info.febvre.Komikku
    io.github.alainm23.planify
    it.mijorus.smile
    org.cryptomator.Cryptomator
    org.gnome.Loupe
    org.libreoffice.LibreOffice
    org.mozilla.firefox
    org.mozilla.Thunderbird
    org.pipewire.Helvum
  '';
  systemScripts = import ./system-scripts.nix { inherit pkgs flatpaks; };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        configurationLimit = 5;
        efiSupport = true;
        device = "nodev";
        # on windows use: bcdedit /set "{bootmgr}" path \EFI\NIXOS-BOOT\GRUBX64.EFI
        extraEntries = ''
          menuentry "Windows 11" --class windows {
            insmod part_gpt
            insmod fat
            insmod chain
            search --no-floppy --fs-uuid --set=root A27E-D58C
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
      grub2-theme = {
        enable = true;
        theme = "stylish";
        icon = "color";
        screen = "ultrawide2k";
      };
      timeout = 10;
    };
    kernel.sysctl = {
      "vm.swappiness" = 1;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "amd_pstate=active" ];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/0b8080ed-91bb-4528-981d-b1c973581621";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  hardware = {
    bluetooth.enable = true;
    enableAllFirmware = true;
  };

  networking = {
    hostName = "watt-the-hell";
    nameservers = [
      "94.140.14.14" # AdGuard
      "94.140.15.15" # AdGuard
      "9.9.9.9" # Quad9
    ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      settings."global-dns-domain-*" = {
        servers = "94.140.14.14,94.140.15.15,9.9.9.9";
        options = "";
      };
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        32400 # plex
      ];
    };
  };

  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "Sun 00:00";
      persistent = true;
      options = "--delete-older-than 14d";
      randomizedDelaySec = "30min";
    };
    optimise = {
      automatic = true;
      dates = "Mon 00:00";
      persistent = true;
      randomizedDelaySec = "30min";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "richard"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  system = {
    stateVersion = "25.05";
    autoUpgrade = {
      enable = true;
      persistent = true;
      dates = "Sat 00:00";
      randomizedDelaySec = "30min";
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
      ];
    };
  };

  environment = {
    etc."xdg/mimeapps.list".text = ''
      [Default Applications]
      image/jpeg=org.gnome.Loupe.desktop
      image/png=org.gnome.Loupe.desktop
      text/html=org.mozilla.firefox.desktop
      video/mp4=mpv.desktop
      x-scheme-handler/http=org.mozilla.firefox.desktop
      x-scheme-handler/https=org.mozilla.firefox.desktop
    '';
    systemPackages = with pkgs; [
      adwaita-icon-theme
      apple-cursor
      bat
      bazaar
      bottom
      chafa
      chezmoi
      delta
      devenv
      distrobox
      elephant # walker dependency
      eza
      fd
      ffmpegthumbnailer
      fzf
      gexiv2 # nautilus-media-columns dependency
      git
      git-lfs
      gnome-disk-utility
      gst_all_1.gstreamer # nautilus-media-columns dependency
      gst_all_1.gst-plugins-base # nautilus-media-columns dependency
      gst_all_1.gst-plugins-good # nautilus-media-columns dependency
      gst_all_1.gst-plugins-bad # nautilus-media-columns dependency
      gst_all_1.gst-libav # nautilus-media-columns dependency
      hyprpaper
      inputs.ironbar.packages.${pkgs.system}.default
      jq
      lazygit
      macchina
      micro
      mpv
      nautilus
      nautilus-python # nautilus-media-columns dependency
      nixfmt
      podman-compose
      psst
      qemu
      rclone
      resources
      ripgrep
      rnr
      starship
      swaynotificationcenter
      swayosd
      tree
      uutils-coreutils-noprefix
      vivid
      walker
      wezterm
      wl-clipboard-rs
      xwayland-satellite
      yazi
      zellij
    ];
    sessionVariables = {
      NAUTILUS_4_EXTENSION_DIR = "/run/current-system/sw/lib/nautilus/extensions-4"; # nautilus-media-columns dependency
      GST_PLUGIN_SYSTEM_PATH_1_0 = "/run/current-system/sw/lib/gstreamer-1.0"; # nautilus-media-columns dependency
    };
  };

  programs = {
    direnv = {
      enable = true;
    };
    fish.enable = true;
    niri.enable = true;
  };

  services = {
    displayManager.ly.enable = true;
    flatpak.enable = true;
    gnome.sushi.enable = true;
    gvfs.enable = true;
    pipewire.enable = true;
    playerctld.enable = true;

    resolved = {
      enable = true;
      settings.Resolve = {
        DNSOverTLS = "opportunistic";
        FallbackDNS = "";
      };
    };

    xserver.xkb = {
      layout = "us";
    };
  };

  security.rtkit.enable = true; # Pipewire realtime priority

  virtualisation.podman.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-termfilepickers < wait for merged
      xdg-desktop-portal-wlr
    ];
  };

  users = {
    defaultUserShell = pkgs.fish;
    users."richard" = {
      isNormalUser = true;
      description = "richard";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users."richard" =
    {
      pkgs,
      lib,
      config,
      ...
    }:

    let
      username = config.home.username;
      github = "RichardFevrier"; # chezmoi config
      userScripts = import ./user-scripts.nix {
        inherit
          pkgs
          lib
          username
          github
          ;
      };
    in
    {
      home = {
        stateVersion = "25.05";

        # mask gcr-ssh-agent.service & gcr-ssh-agent.socket started by gvfs
        activation.maskGcrSshAgent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          $DRY_RUN_CMD systemctl --user mask gcr-ssh-agent.service gcr-ssh-agent.socket 2>/dev/null || true
        '';
      };

      systemd.user = {
        sessionVariables = {
          SSH_AUTH_SOCK = "/home/${username}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock";
        };

        services."${username}-init" = userScripts.userInitService;
        services.bitwarden-setup = userScripts.bitwardenSetupService;
      };
    };

  systemd.services.flatpak-init = systemScripts.flatpakInitService;
  systemd.services.flatpak-update = systemScripts.flatpakUpdateService;
  systemd.timers.flatpak-update = systemScripts.flatpakUpdateTimer;
  systemd.services.micro-update = systemScripts.microUpdateService;
  systemd.timers.micro-update = systemScripts.microUpdateTimer;
  systemd.services.yazi-update = systemScripts.yaziUpdateService;
  systemd.timers.yazi-update = systemScripts.yaziUpdateTimer;
}
