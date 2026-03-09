1. Restore your ssh keys
2. Update `configuration.nix` and `flake.nix` files
3. Rebuild:
```
sudo nixos-rebuild switch --flake /etc/nixos
```
4. Update default audio input/output
```
wpctl status
wpctl set-default X
```
