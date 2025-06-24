# Dotfiles
First things first use the `chezmoi.yaml.example` to setup your `~/.config/chezmoi/chezmoi.yaml`
## Dotfiles Manager
[Chezmoi](https://www.chezmoi.io)
Create a file at `~/.config/chezmoi/chezmoi.yaml` and put:
```
data:
  email: # your email used for git
  name: # your name used for git
```
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
ya pkg ...
```
- KKV9/compress
- Lil-Dank/lazygit
- Rolv-Apneseth/starship
- yazi-rs/plugins:toggle-pane
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
- lsp
- quoter
- urlopen
- wc
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
## Wallpaper displayer
[Hyprpaper](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/)
## Notifications manager
[SwayNC](https://github.com/ErikReider/SwayNotificationCenter)
## OSD
[SwayOSD](https://github.com/ErikReider/SwayOSD)
## App launcher
[Walker](https://github.com/abenz1267/walker)
