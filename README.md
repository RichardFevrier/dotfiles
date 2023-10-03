# Configuration

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
