1. Restore your ssh keys

2. Update nix channels:
```
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
```
3. Update `configuration.nix` file
4. Rebuild:
```
sudo nixos-rebuild switch
```
