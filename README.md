# Dotfiles
## Dotfiles Manager
[Chezmoi](https://www.chezmoi.io/)
```
$ chezmoi init --apply RichardFevrier
```
```
$ chezmoi update -v
```
## Desktop Environment (Linux)
[Hyprland](https://hyprland.org/)
## Terminal
[Wezterm](https://wezfurlong.org/wezterm/index.html)
## Unix shell
[Fish](https://fishshell.com/)
#### Change default shell
##### Linux
```
$ sudo usermod --shell /usr/bin/fish $(whoami)
```
##### macOS
```
$ sudo dscl . -create /Users/$(whoami) UserShell /usr/local/bin/fish
```
## Shell prompt
[Starship](https://starship.rs/) (`Nerd Font` already provided by `Wezterm`)
## Text Editor
[Micro](https://micro-editor.github.io/)  
  
Do the following if you see a different configuration when using `sudo micro ...` (usually means that `$HOME` env var is different between `root` and `non-root` users):
```
$ sudo visudo
```
```
Defaults    env_keep += "MICRO_CONFIG_HOME"
```
## Logitech devices (Linux)
[Solaar](https://pwr-solaar.github.io/Solaar/)
