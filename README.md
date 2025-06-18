# Dotfiles
## Dotfiles Manager
[Chezmoi](https://www.chezmoi.io)
```
$ chezmoi init --apply RichardFevrier
```
```
$ chezmoi update -v
```
## App manager
[App](https://hkdb.github.io/app)
```
$ app -m brew install ...
```
```
$ app -r brew
```
## Font
[Fira Code](https://github.com/tonsky/FiraCode)  (files included for linux and macOS)
## Terminal
[Wezterm](https://wezfurlong.org/wezterm/index.html)
## Unix shell
[Fish](https://fishshell.com)
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
[Starship](https://starship.rs) (`Nerd Font` already provided by `Wezterm`)
## File Manager
[Yazi](https://yazi-rs.github.io)
```
ya pack -a/u ...
```
- yazi-rs/plugins:max-preview
- KKV9/compress
## Text Editor
[Micro](https://micro-editor.github.io)

Do the following if you see a different configuration when using `sudo micro ...` (usually means that `$HOME` env var is different between `root` and `non-root` users):
```
$ sudo visudo
```
```
Defaults    env_keep += "MICRO_CONFIG_HOME"
```
Plugins
```
$ micro -plugin install/update ...
```
- fzfinder
- lsp
- quoter
- urlopen
- wc
- yazi
## Git Manager
[Lazygit](https://github.com/jesseduffield/lazygit)
## Cat replacement
[Bat](https://github.com/sharkdp/bat)
## Find replacement
[Fd](https://github.com/sharkdp/fd)
## Fuzzy Finder
[Fzf](https://junegunn.github.io/fzf)
#### Tips
`Ctrl+R` to fuzzy the commands history
## Ls replacement
[Eza](https://eza.rocks)
## Keyboard layout
[Qwerty-Lafayette](https://qwerty-lafayette.org) (files included for linux and macOS)
#### Tips
To fix inverted keys e.g: `@/#` -> `</>`
##### Linux
Create `/etc/udev/hwdb.d/60-keyboard-logitech-craft.hwdb` (use `evtest` to find the right keys)
```
evdev:name:*Craft*:*
    KEYBOARD_KEY_70064=grave
    KEYBOARD_KEY_70035=102n
```
Then `$ sudo systemd-hwdb update` and `$ sudo udevadm trigger`  
##### macOS
Use [Karabiner-Elements](https://karabiner-elements.pqrs.org/) (config included)
# Linux
## Desktop Environment
[Niri](https://github.com/YaLTeR/niri)
## Status bar
[Waybar](https://github.com/Alexays/Waybar)
