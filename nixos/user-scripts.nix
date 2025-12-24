{ pkgs, username, github }:

let
  userInit = pkgs.writeShellScript "${username}-init" ''
    #!/usr/bin/env bash
    set -euo pipefail

    ${pkgs.coreutils}/bin/mkdir -p ~/.config/chezmoi
    ${pkgs.curl}/bin/curl -L https://raw.githubusercontent.com/${github}/dotfiles/main/dot_config/chezmoi/chezmoi.yaml -o ~/.config/chezmoi/chezmoi.yaml
    ${pkgs.chezmoi}/bin/chezmoi init --apply ${github} && ${pkgs.chezmoi}/bin/chezmoi update
    PATH=${pkgs.git}/bin:$PATH ${pkgs.yazi}/bin/ya pkg install
    ${pkgs.micro}/bin/micro -plugin install lsp quoter urlopen wc
  '';

  userInitPost = pkgs.writeShellScript "${username}-init-post" ''
    #!/usr/bin/env bash
    set -euo pipefail

    ${pkgs.findutils}/bin/find /home/${username}/.var/ -maxdepth 1 -type f -name '${username}-init-hash-*' -exec ${pkgs.coreutils}/bin/rm -f {} +
    ${pkgs.coreutils}/bin/touch /home/${username}/.var/${username}-init-hash-${builtins.hashString "sha256" (toString userInit)}
  '';

  userInitService = {
    Unit = {
      Description = "Run ${username} init";
      ConditionPathExists = ''!/home/${username}/.var/${username}-init-hash-${builtins.hashString "sha256" (toString userInit)}'';
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = userInit;
      ExecStartPost = userInitPost;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
in {
  inherit userInitService;
}
