# Dotfiles for GNU stow

Use these dotfiles by running:

```bash
stow -v DOTFILESFOLDERYOUWANTTOINSTALLHERE -t ~

```
## Arch Setup


```bash
# arch: https://wiki.archlinux.org/title/Installation_guide
loadkeys de-latin1
# archinstall:
# 1. choose a Hyprland Profile!,
# 2. seatd,

sudo pacman -Sy archinstall
archinstall

# logged into your archinstall
vim .config/hypr/hyprland.conf
# put this in input:
#input {
#    kb_layout = de
#    # +kb_options for alt-l = '@' like macos
#    # i personally had some problems with "<" and "^" beeing exchanged, so i edited the /usr/share/X11/xkb/symbols/de -> xkb_symbols "mac" to switch the contents of key <TLDE> and <LSGT>
#    kb_variant = mac
#    kb_options = lv3:lalt_switch
#
#    repeat_rate = 50
#    repeat_delay = 250
#}

# the keys "<" and "^" where still switched,
# so i switched them in the mac variant
# TLDE <-> LSGT in xkb_symbols "mac"
# remember to backup
sudo cp /usr/share/X11/xkb/symbols/de /usr/share/X11/xkb/symbols/de-old
sudo vim /usr/share/X11/xkb/symbols/de
hyprctl reload

mkdir ~/git; cd ~/git;

# install packages:
sudo pacman -Sy otf-commit-mono-nerd nushell git firefox zoxide starship curl base-devel ghostty bat stow waybar wiremix blueberry less fd tree
sudo pacman -Sy niri xwayland-satellite swaylock swayidle wl-clipboard xdg-desktop-portal-gtk xdg-desktop-portal-gnome gnome-keyring wlr-which-key # niri deps
git clone git@github.com:JonasLeonhard/dotfiles.git # this might require adding your ssh key to github https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent; also do: https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key

sudo pacman -Sy nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec ghostty # for nemo's terminal open feature

# AUR packages w. yay:
git clone --branch yay --single-branch https://github.com/archlinux/aur.git yay; cd yay; makepkg -si;
yay -S neovim-git tofi btop

# GNU Stow: install dotfiles
stow -v bat dunst ghostty git nushell nvim starship tofi waybar swaylock -t ~

# bat theme, starship & zoxide init
bat cache --build
starship init nu | save -f ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.cache/zoxide/init.nu

# Sddm theme
stow -v sddm -t /
cd ~/git; git clone https://github.com/GistOfSpirit/TerminalStyleLogin;
cd TerminalStyleLogin;
./scripts/build;
sudo mv build /usr/share/sddm/themes/terminal;
sudo nvim /usr/share/sddm/themes/terminal/theme.conf

# now we can remove the old stuff
sudo pacman -R kitty

# Theming (https://github.com/P-ti-bob/hyprland/blob/main/docs/theming.md)
# Set gtk font & theme to dark + CommitMono
pacman -S nwg-look
# style qt + kde
sudo -E kvantummanager
pacman -S qt5ct qt6ct kvantum
```

