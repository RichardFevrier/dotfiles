{ pkgs, flatpaks }:

let
  flatpakInit = pkgs.writeShellScript "flatpak-init" ''
    #!/usr/bin/env bash
    set -euo pipefail

    ${pkgs.flatpak}/bin/flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    desired="${flatpaks}"
    installed="''$(${pkgs.flatpak}/bin/flatpak list --app --columns=application)"

    for app in ''$desired; do
      if [[ ! ''$installed == *''$app* ]]; then
        ${pkgs.flatpak}/bin/flatpak install --system --noninteractive flathub ''$app
      fi
    done

    for app in ''$installed; do
      if [[ ! ''$desired == *''$app* ]]; then
        ${pkgs.flatpak}/bin/flatpak uninstall --system --noninteractive --delete-data ''$app
      fi
    done
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
in {
  inherit flatpakInitService;
}
