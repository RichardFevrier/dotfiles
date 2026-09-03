{ pkgs, ... }:
{
  nixGcCleanup = pkgs.writeShellScript "nix-gc-cleanup" ''
    set -euo pipefail

    KEEP_MIN=2
    MAX_AGE_DAYS=14
    PROFILE="$1"
    cutoff=$(${pkgs.coreutils}/bin/date -d "-''${MAX_AGE_DAYS} days" +%s)

    [ -e "$PROFILE" ] || { echo "skip missing $PROFILE"; exit 0; }

    mapfile -t lines < <(${pkgs.nix}/bin/nix-env -p "$PROFILE" --list-generations)
    total=''${#lines[@]}
    keep_from=$(( total - KEEP_MIN ))
    to_delete=()

    for i in "''${!lines[@]}"; do
      (( i >= keep_from )) && break

      line="''${lines[$i]}"
      date_str=$(${pkgs.gawk}/bin/awk '{print $2, $3}' <<< "$line")

      gen_ts=$(${pkgs.coreutils}/bin/date -d "$date_str" +%s 2>/dev/null || echo 0)
      if [ "$gen_ts" -gt 0 ] && [ "$gen_ts" -lt "$cutoff" ]; then
        num=$(${pkgs.gawk}/bin/awk '{print $1}' <<< "$line")
        to_delete+=("$num")
      fi
    done

    if [ ''${#to_delete[@]} -gt 0 ]; then
      echo "Deleting generations: ''${to_delete[*]}"
      ${pkgs.nix}/bin/nix-env -p "$PROFILE" --delete-generations "''${to_delete[@]}"
    else
      echo "Nothing to delete"
    fi
  '';
}
