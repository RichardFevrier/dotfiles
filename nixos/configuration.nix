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
  boot = {
    loader = {
      limine = {
        enable = true;
        efiSupport = true;
        maxGenerations = 5;
        # on windows use: bcdedit /set "{bootmgr}" path \EFI\BOOT\BOOTX64.EFI
        extraEntries = ''
          /Windows 11
            protocol: efi
            path: guid(9b1d5845-88d4-42ba-9fee-c459252ef7f2):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
        # https://search.nixos.org/options?&query=boot.loader.limine&show=option:boot.loader.limine.secureBoot.enable
        #
        # to enable secure boot:
        #   1. BIOS: disable secure boot, set mode to custom, disable default factory keys
        #   2. sudo sbctl create-keys (or restore `/var/lib/sbctl` if you already have some)
        #   3. sudo sbctl enroll-keys --microsoft -f
        #   4. enable this var
        #   5. BIOS: enable secure boot
        secureBoot.enable = true;
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

  zramSwap = {
    enable = true;
    priority = 100;
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
      _7zz
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
      sbctl
      slirp4netns
      starship
      swaynotificationcenter
      swayosd
      tree
      tree-sitter
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
    nirinit.enable = true;
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
      };

      systemd.user = {
        sessionVariables = {
          SSH_AUTH_SOCK = "/home/${username}/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock";
        };

        services = {
          "${username}-init" = userScripts.userInitService;
          "${username}-startup" = userScripts.userStartupService;
          "${username}-midnight" = userScripts.userMidnightService;
        };

        timers."${username}-midnight" = userScripts.userMidnightTimer;
      };
    };

  systemd = {
    services = {
      system-init = systemScripts.systemInitService;
      system-midnight = systemScripts.systemMidnightService;
    };

    timers.system-midnight = systemScripts.systemMidnightTimer;

    user = {
      # mask gcr-ssh-agent started by gvfs
      services.gcr-ssh-agent.enable = false;
      sockets.gcr-ssh-agent.enable = false;
      # mask speech synthesis
      services.speech-dispatcher.enable = false;
      sockets.speech-dispatcher.enable = false;
    };
  };
}
