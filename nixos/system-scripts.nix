{ pkgs, flatpaks }:

let
  flatpakInit = pkgs.writeShellScript "flatpak-init" ''
    #!/usr/bin/env bash
    set -euo pipefail

    ${pkgs.flatpak}/bin/flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    desired="${flatpaks}"
    installed="''$(${pkgs.flatpak}/bin/flatpak list --app --columns=app,ref,origin | tail -n +1)"

    while IFS= read -r app; do
      if [[ ! "''$installed" == *"''$app"* ]]; then
        ${pkgs.flatpak}/bin/flatpak install --system --noninteractive flathub "''$app"
      fi
    done <<< "''$desired"

    while IFS= read -r line; do
      origin=''$(echo "''$line" | ${pkgs.gawk}/bin/awk '{print ''$3}')
      if [[ ! "''$origin" == "flathub" ]]; then
        continue
      fi
      app=''$(echo "''$line" | ${pkgs.gawk}/bin/awk '{print ''$1}')
      if [[ ! "''$desired" == *"''$app"* ]]; then
        ref=''$(echo "''$line" | ${pkgs.gawk}/bin/awk '{print ''$2}')
        ${pkgs.flatpak}/bin/flatpak uninstall --system --noninteractive --delete-data "''$ref"
      fi
    done <<< "''$installed"
  '';

  flatpakInitPost = pkgs.writeShellScript "flatpak-init-post" ''
    #!/usr/bin/env bash
    set -euo pipefail

    ${pkgs.findutils}/bin/find /var/ -maxdepth 1 -type f -name 'flatpak-init-hash-*' -exec ${pkgs.coreutils}/bin/rm -f {} +
    ${pkgs.coreutils}/bin/touch /var/flatpak-init-hash-${builtins.hashString "sha256" (toString flatpakInit)}
  '';

  flatpakInitService = {
    unitConfig = {
      Description = "Run flatpak init";
      ConditionPathExists = ''!/var/flatpak-init-hash-${builtins.hashString "sha256" (toString flatpakInit)}'';
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = flatpakInit;
      ExecStartPost = flatpakInitPost;
    };
    wantedBy = [ "multi-user.target" ];
  };

  flatpakUpdateService = {
    unitConfig = {
      Description = "Run system flatpak update";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.flatpak}/bin/flatpak update --assumeyes --noninteractive --system";
    };
  };

  flatpakUpdateTimer = {
    unitConfig = {
      Description = "Update system Flatpaks daily";
    };
    timerConfig = {
      OnCalendar = "Mon..Sun 00:00";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };

  microUpdateService = {
    unitConfig = {
      Description = "Run Micro pkgs update";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.micro}/bin/micro -plugin update";
    };
  };

  microUpdateTimer = {
    unitConfig = {
      Description = "Update Micro pkgs daily";
    };
    timerConfig = {
      OnCalendar = "Mon..Sun 00:00";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };

  yaziUpdateService = {
    unitConfig = {
      Description = "Run Yazi pkgs update";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.yazi}/bin/ya pkg upgrade";
    };
  };

  yaziUpdateTimer = {
    unitConfig = {
      Description = "Update Yazi pkgs daily";
    };
    timerConfig = {
      OnCalendar = "Mon..Sun 00:00";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
in {
  inherit flatpakInitService flatpakUpdateService flatpakUpdateTimer microUpdateService microUpdateTimer yaziUpdateService yaziUpdateTimer;
}
