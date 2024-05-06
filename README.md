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
###### Arm
```
$ sudo dscl . -create /Users/$(whoami) UserShell /opt/homebrew/bin/fish
```
###### Intel
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
[Ergo-L dev angle-mod](https://github.com/Nuclear-Squid/ergol) (files included for linux and macOS)
#### Tips
To fix inverted keys e.g: `@/#` -> `</>`
##### Linux
Create `$ /etc/udev/hwdb.d/60-keyboard-logitech-craft.hwdb` (use `evtest` to find the right keys)
```
evdev:name:*Craft*:*
    KEYBOARD_KEY_70064=grave
    KEYBOARD_KEY_70035=102n
```
Then `$ sudo systemd-hwdb update` and `$ sudo udevadm trigger`  
##### macOS
Use [Karabiner-Elements](https://karabiner-elements.pqrs.org/) (config included)
