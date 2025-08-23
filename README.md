# Dotfiles for GNU stow

Use these dotfiles by running:

```bash
stow -v DOTFILESFOLDERYOUWANTTOINSTALLHERE -t ~

```
## Special Cases:

### sddm

install sddm theme "terminal":

```bash
stow -v sddm -t /
git clone https://github.com/GistOfSpirit/TerminalStyleLogin;
cd TerminalStyleLogin;
./scripts/build;
sudo mv build /usr/share/sddm/themes/terminal;
sudo nvim /usr/share/sddm/themes/terminal/theme.conf
```
