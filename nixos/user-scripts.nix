{
  pkgs,
  lib,
  username,
  github,
}:

let
  userInitScript = pkgs.writeShellScript "${username}-init" ''
    #!/usr/bin/env bash
    set -euo pipefail

    ### Chezmoi

    ${pkgs.coreutils}/bin/mkdir -p ~/.config/chezmoi
    ${pkgs.curl}/bin/curl -L https://raw.githubusercontent.com/${github}/dotfiles/main/dot_config/chezmoi/chezmoi.yaml -o ~/.config/chezmoi/chezmoi.yaml
    ${pkgs.chezmoi}/bin/chezmoi init --apply ${github} && ${pkgs.chezmoi}/bin/chezmoi update

    ### Micro

    if [ -f ~/.config/micro/plug/list.txt ]; then
      ${pkgs.coreutils}/bin/cat ~/.config/micro/plug/list.txt | ${pkgs.findutils}/bin/xargs ${pkgs.micro}/bin/micro -plugin install
    fi

    ### Yazi

    PATH=${pkgs.git}/bin:$PATH ${pkgs.yazi}/bin/ya pkg install
  '';

  userInitService = {
    Unit = {
      Description = "${username} init service";
      ConditionPathExists = "!/home/${username}/.var/${username}-init-hash-${builtins.hashString "sha256" (toString userInitScript)}";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = userInitScript;
      ExecStartPost = pkgs.writeShellScript "${username}-init-post" ''
        #!/usr/bin/env bash
        set -euo pipefail

        ${pkgs.findutils}/bin/find /home/${username}/.var/ -maxdepth 1 -type f -name '${username}-init-hash-*' -exec ${pkgs.coreutils}/bin/rm -f {} +
        ${pkgs.coreutils}/bin/touch /home/${username}/.var/${username}-init-hash-${builtins.hashString "sha256" (toString userInitScript)}
      '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  userStartupService = {
    Unit = {
      Description = "${username} startup service";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "${username}-startup" ''
        #!/usr/bin/env bash
        set -euo pipefail

        ### Flatpak

        ${pkgs.flatpak}/bin/flatpak override --user --nodevice=all --nofilesystem=host --nofilesystem=home --nofilesystem=/home/${username}/.ssh --nofilesystem=/home/${username}/.gnupg --no-talk-name=org.freedesktop.Flatpak

        ### Bitwarden

        BITWARDEN_PATH="/home/${username}/.var/app/com.bitwarden.desktop"

        DATA="$BITWARDEN_PATH/config/Bitwarden/data.json"
        content=$(${pkgs.jq}/bin/jq '
          .["global_desktopSettings_trayEnabled"] = true |
          .["global_desktopSettings_closeToTray"] = true |
          .["global_desktopSettings_startToTray"] = true |
          .["global_desktopSettings_openAtLogin"] = true |
          .["global_desktopSettings_sshAgentEnabled"] = true
        ' "$DATA")
        echo "$content" > "$DATA"
      '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  userMidnightService = {
    Unit = {
      Description = "${username} midnight service";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "${username}-midnight" ''
        #!/usr/bin/env bash
        set -euo pipefail

        ### Micro

        ${pkgs.micro}/bin/micro -plugin update

        ### Yazi

        ${pkgs.yazi}/bin/ya pkg upgrade
      '';
    };
  };

  userMidnightTimer = {
    Unit = {
      Description = "${username} midnight timer";
    };
    Timer = {
      OnCalendar = "Mon..Sun 00:00";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
in
{
  inherit userInitService userStartupService userMidnightService userMidnightTimer;
}
