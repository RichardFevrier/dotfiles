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
## Font
[Meslo LG](https://github.com/andreberg/Meslo-Font)
## Terminal
[Wezterm](https://wezfurlong.org/wezterm/index.html)
## Unix shell
[Fish](https://fishshell.com/)
#### Change default shell
##### Linux
```
$ sudo usermod --shell $(which fish) $(whoami)
```
##### macOS
```
$ sudo dscl . -create /Users/$(whoami) UserShell $(which fish)
```
## Shell prompt
[Starship](https://starship.rs/) (`Nerd Font` already provided by `Wezterm`)
## Fuzzy Finder
[Fzf](https://github.com/junegunn/fzf)
#### Tips
`Ctrl+R` to fuzzy the commands history
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
## Cat replacement
[Bat](https://github.com/sharkdp/bat)
## Find replacement
[Fd](https://github.com/sharkdp/fd)
## Ls replacement
[Eza](https://github.com/eza-community/eza)
## Keyboard layout
[Qwerty-Lafayette](https://github.com/fabi1cazenave/qwerty-lafayette) (files included for linux and macOS)
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
