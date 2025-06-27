{ config, pkgs, ... }:

let
  flatpaks="org.mozilla.firefox org.pipewire.Helvum it.mijorus.smile io.github.alainm23.planify";
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
      systemd-boot.enable = true;
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
      dates = "weekly";
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
    options = "--delete-older-than 7d";
  };

  networking = {
    hostName = "watt-the-hell";
    networkmanager.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    apple-cursor
    bat
    bitwarden-cli
    bottom
    chafa
    chezmoi
    distrobox
    eza
    delta
    fd
    ffmpegthumbnailer
    file
    fzf
    git
    git-lfs
    gnome-software
    hyperfine
    hyprpaper
    lazygit
    macchina
    micro
    mpv
    podman
    podman-compose
    pre-commit
    psst
    qemu
    ripdrag
    rnr
    starship
    swaynotificationcenter
    swayosd
    tree
    vivid
    walker
    waybar
    wezterm
    wl-clipboard-rs
    yazi
    zellij
  ];

  security.rtkit.enable = true;

  services = {
    # blueman.enable = true;
    # desktopManager.gnome.enable = true;
    # displayManager.gdm.enable = true;
    displayManager.ly.enable = true;
    flatpak.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
    };
    playerctld.enable = true;
    # printing.enable = true;
    # xserver.enable = true;
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.niri.enable = true;
  # programs.waybar.enable = true;

  systemd.services.flatpak-init = systemScripts.flatpakInitService;

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

    # gtk = {
    #   enable = true;
    #   cursorTheme = {
    #     name = "Vanilla-DMZ";
    #     size = 5;
    #   };
#       gtk3 = {
#         extraConfig = {
#           gtk-application-prefer-dark-theme = 1;
#         };
#       };
#
#       gtk4 = {
#         extraConfig = {
#           gtk-application-prefer-dark-theme = 1;
#         };
#       };
    # };
#
#     qt = {
#       enable = true;
#       platformTheme.name = "Adwaita-dark";
#       style = {
#         name = "Adwaita-dark";
#         package = pkgs.adwaita-qt;
#       };
#     };
  };
}
