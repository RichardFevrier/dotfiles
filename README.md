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
[Niri](https://github.com/YaLTeR/niri)
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
#### Plugins
- lsp
- quoter
- wc
## Keyboard layout
[Qwerty-Lafayette](https://github.com/fabi1cazenave/qwerty-lafayette/tree/v0.9)
# (Linux)
To fix inverted keys e.g: `@/#` -> `</>`  
Create `$ micro /etc/udev/hwdb.d/60-keyboard-logitech-craft.hwdb` (use `evtest` to find the right keys)
```
evdev:name:*Craft*:*
    KEYBOARD_KEY_70064=grave
    KEYBOARD_KEY_70035=102n
```
Then `$ sudo systemd-hwdb update` and `$ sudo udevadm trigger`  
