{ config, pkgs, ... }:

let
  flatpaks=''
  app.fotema.Fotema
  codes.loers.Karlender
  com.dropbox.Client
  com.github.maoschanz.drawing
  com.github.tchx84.Flatseal
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
      <home-manager/nixos>
    ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "amd_pstate=active" ];
  };

  fileSystems."/mnt/data" =
  { device = "/dev/disk/by-uuid/0b8080ed-91bb-4528-981d-b1c973581621";
    fsType = "ext4";
    options = [ "defaults" ];
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
      persistent = true;
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-old";
  };

  networking = {
    hostName = "watt-the-hell";
    networkmanager.enable = true;
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
      bottom
      chafa
      chezmoi
      delta
      distrobox
      eza
      fd
      ffmpegthumbnailer
      file
      fzf
      git
      git-lfs
      gnome-software
      hyperfine
      hyprpaper
      jq
      lazygit
      libqalculate
      macchina
      micro
      mpv
      nautilus
      podman-compose
      pre-commit
      psst
      qemu
      resources
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

  security.rtkit.enable = true;

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
      gnome-keyring
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

  home-manager.users."${username}" = { pkgs, ... }: {
    home.stateVersion = "25.05";

    systemd.user.services."${username}-init" = userScripts.userInitService;

    dconf = {
      settings = {
        "org/gnome/desktop/interface" = {
  	      color-scheme = "prefer-dark";
        };
      };
    };
  };
}
