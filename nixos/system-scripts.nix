{ pkgs, flatpaks }:

let
  systemInitScript = pkgs.writeShellScript "system-init" ''
    #!/usr/bin/env bash
    set -euo pipefail

    ### Flatpak

    ${pkgs.flatpak}/bin/flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    desired="${flatpaks}"
    installed="''$(${pkgs.flatpak}/bin/flatpak list --app --columns=app,ref,origin | tail -n +1)"

    while IFS= read -r app; do
      if [[ ! "''$installed" == *"''$app"* ]]; then
        ${pkgs.flatpak}/bin/flatpak install --system --noninteractive flathub "''$app"
      fi
    done <<< "''$desired"
  '';

  systemInitService = {
    unitConfig = {
      Description = "system init service";
      ConditionPathExists = "!/var/system-init-hash-${builtins.hashString "sha256" (toString systemInitScript)}";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = systemInitScript;
      ExecStartPost = pkgs.writeShellScript "system-init-post" ''
        #!/usr/bin/env bash
        set -euo pipefail

        ${pkgs.findutils}/bin/find /var/ -maxdepth 1 -type f -name 'system-init-hash-*' -exec ${pkgs.coreutils}/bin/rm -f {} +
        ${pkgs.coreutils}/bin/touch /var/system-init-hash-${builtins.hashString "sha256" (toString systemInitScript)}
      '';
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemMidnightService = {
    unitConfig = {
      Description = "system midnight service";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "system-midnight" ''
        #!/usr/bin/env bash
        set -euo pipefail

        ### Flatpak

        ${pkgs.flatpak}/bin/flatpak update --assumeyes --noninteractive --system
      '';
    };
  };

  systemMidnightTimer = {
    unitConfig = {
      Description = "system midnight timer";
    };
    timerConfig = {
      OnCalendar = "Mon..Sun 00:00";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
in
{
  inherit
    systemInitService
    systemMidnightService
    systemMidnightTimer
    ;
}
