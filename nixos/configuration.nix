{ config, pkgs, ... }:

let
  flatpaks=''
  app.fotema.Fotema
  codes.loers.Karlender
  com.dropbox.Client
  com.github.PintaProject.Pinta
  com.github.tchx84.Flatseal
  com.github.wwmm.easyeffects
  info.febvre.Komikku
  io.github.alainm23.planify
  it.mijorus.smile
  org.cryptomator.Cryptomator
  org.gnome.Loupe
  org.libreoffice.LibreOffice
  org.mozilla.Thunderbird
  org.mozilla.firefox
  org.pipewire.Helvum
  '';
  systemScripts = import ./system-scripts.nix { inherit pkgs flatpaks; };

  username="richard";
  github="RichardFevrier"; # chezmoi config
  userScripts = import ./user-scripts.nix { inherit pkgs username github; };
in
{
  imports =
    [
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
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "amd_pstate=active" ];
  };

  fileSystems."/mnt/data" =
  { device = "/dev/disk/by-uuid/0b8080ed-91bb-4528-981d-b1c973581621";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  hardware = {
    bluetooth.enable = true;
    enableAllFirmware = true;
  };

  system = {
    stateVersion = "25.05";
    autoUpgrade = {
      enable = true;
      dates = "Sat 00:00";
      flags = ["--upgrade-all"];
      persistent = true;
      randomizedDelaySec = "30min";
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
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "${username}" ];
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = "watt-the-hell";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 32400 ]; # plex
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    etc."xdg/mimeapps.list".text = ''
      [Default Applications]
      x-scheme-handler/http=org.mozilla.firefox.desktop
      x-scheme-handler/https=org.mozilla.firefox.desktop
      image/jpeg=org.gnome.Loupe.desktop
      image/png=org.gnome.Loupe.desktop
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
      git
      git-lfs
      gnome-disk-utility
      hyprpaper
      lazygit
      macchina
      micro
      mpv
      nautilus
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
      waybar
      wezterm
      wl-clipboard-rs
      xwayland-satellite
      yazi
      zellij
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  security.rtkit.enable = true; # Pipewire realtime priority

  services = {
    # desktopManager.gnome.enable = true;
    # displayManager.gdm.enable = true;
    displayManager.ly.enable = true;
    flatpak.enable = true;
    gnome.sushi.enable = true;
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    playerctld.enable = true;
    # printing.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

  virtualisation.podman.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # xdg-desktop-portal-termfilepickers < wait for merged
      xdg-desktop-portal-wlr
      # xdg-desktop-portal-gtk
      # xdg-desktop-portal-gnome
    ];
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.niri.enable = true;

  systemd.services.flatpak-init = systemScripts.flatpakInitService;
  systemd.services.flatpak-update = systemScripts.flatpakUpdateService;
  systemd.timers.flatpak-update = systemScripts.flatpakUpdateTimer;
  systemd.services.micro-update = systemScripts.microUpdateService;
  systemd.timers.micro-update = systemScripts.microUpdateTimer;
  systemd.services.yazi-update = systemScripts.yaziUpdateService;
  systemd.timers.yazi-update = systemScripts.yaziUpdateTimer;

  users = {
    users."${username}" = {
      isNormalUser = true;
      description = "${username}";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
    };
  };

  home-manager.users."${username}" = { pkgs, lib, ... }: {
    home.stateVersion = "25.05";

    systemd.user.services."${username}-init" = userScripts.userInitService;

    home.activation.maskGcrSshAgent = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD systemctl --user mask gcr-ssh-agent.service gcr-ssh-agent.socket 2>/dev/null || true
    '';

    programs.keychain = {
      enable = true;
      keys = [ "id_ed25519_${username}" ];
    };

    dconf = {
      settings = {
        "org/gnome/desktop/interface" = {
  	      color-scheme = "prefer-dark";
        };
      };
    };
  };
}
