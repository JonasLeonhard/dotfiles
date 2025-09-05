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


### XKB mac layout custom:

```
// /usr/share/X11/xkb/symbols/de
// Legacy layout for the German Mac, as depicted on
// https://iks.cs.ovgu.de/~elkner/keyboard/mac/germankbd.html.
partial alphanumeric_keys
xkb_symbols "mac" {

    name[Group1]= "German (Macintosh)";

    // key <TLDE>	{[ dead_circumflex, degree, doublelowquotemark, leftdoublequotemark ]};
    key <TLDE>	{[      less,     greater,            bar, dead_belowmacron ]}; // Now has <
    key <AE01>	{[ 1,          exclam,      exclamdown,         notsign             ]};
    key <AE02>	{[ 2,          quotedbl,    leftdoublequotemark,rightdoublequotemark]};
    key <AE03>	{[ 3,          section,     paragraph,          numbersign          ]};
    key <AE04>	{[ 4,          dollar,      cent,               sterling            ]};
    key <AE05>	{[ 5,          percent,     bracketleft,        UFB01               ]}; // ﬁ
    key <AE06>	{[ 6,          ampersand,   bracketright,       dead_circumflex     ]};
    key <AE07>	{[ 7,          slash,       bar,                backslash           ]};
    key <AE08>	{[ 8,          parenleft,   braceleft,          U02DC               ]}; // ˜
    key <AE09>	{[ 9,          parenright,  braceright,         periodcentered      ]};
    key <AE10>	{[ 0,          equal,       notequal,           macron              ]};
    key <AE11>	{[ ssharp,     question,    questiondown,       abovedot            ]};
    key <AE12>	{[ dead_acute, dead_grave,  apostrophe,         U02DA               ]}; // ˚

    key <AD01>	{[ q,          Q,           guillemotleft,      guillemotright      ]};
    key <AD02>	{[ w,          W,           Greek_SIGMA,        doublelowquotemark  ]};
    key <AD03>	{[ e,          E,           EuroSign,           permille            ]};
    key <AD04>	{[ r,          R,           registered,         cedilla             ]};
    key <AD05>	{[ t,          T,           dagger,             U02DD               ]}; // ˝
    key <AD06>	{[ z,          Z,           Greek_OMEGA,        caron               ]};
    key <AD07>	{[ u,          U,           dead_diaeresis,     Aacute              ]};
    key <AD08>	{[ i,          I,           U2044,              Ucircumflex         ]}; // ⁄
    key <AD09>	{[ o,          O,           oslash,             Oslash              ]};
    key <AD10>	{[ p,          P,           Greek_pi,           Greek_PI            ]};
    key <AD11>	{[ udiaeresis, Udiaeresis,  U2022,              degree              ]}; // •
    key <AD12>	{[ plus,       asterisk,    plusminus,          UF8FF               ]}; // Apple logo

    key <AC01>	{[ a,          A,           aring,              Aring               ]};
    key <AC02>	{[ s,          S,           singlelowquotemark, Iacute              ]};
    key <AC03>	{[ d,          D,           partdifferential,   trademark           ]};
    key <AC04>	{[ f,          F,           function,           Idiaeresis          ]};
    key <AC05>	{[ g,          G,           copyright,          Igrave              ]};
    key <AC06>	{[ h,          H,           ordfeminine,        Oacute              ]};
    key <AC07>	{[ j,          J,           masculine,          idotless            ]};
    key <AC08>	{[ k,          K,           Greek_DELTA,        U02C6               ]}; // ˆ
    key <AC09>	{[ l,          L,           at,                 UFB02               ]}; // ﬂ
    key <AC10>	{[ odiaeresis, Odiaeresis,  oe,                 OE                  ]};
    key <AC11>	{[ adiaeresis, Adiaeresis,  ae,                 AE                  ]};
    key <BKSL>	{[ numbersign, apostrophe,  leftsinglequotemark,rightsinglequotemark]};

    // key <LSGT>	{[ less,       greater,     lessthanequal,      greaterthanequal    ]};
    key <LSGT>	{[ dead_circumflex, degree, doublelowquotemark, leftdoublequotemark ]};
    key <AB01>	{[ y,          Y,           yen,                doubledagger        ]};
    key <AB02>	{[ x,          X,           approxeq,           Ugrave              ]};
    key <AB03>	{[ c,          C,           ccedilla,           Ccedilla            ]};
    key <AB04>	{[ v,          V,           radical,            U25CA               ]}; // ◊
    key <AB05>	{[ b,          B,           integral,           U2039               ]}; // ‹
    key <AB06>	{[ n,          N,           dead_tilde,         U203A               ]}; // ›
    key <AB07>	{[ m,          M,           mu,                 breve               ]};
    key <AB08>	{[ comma,      semicolon,   infinity,           ogonek              ]};
    key <AB09>	{[ period,     colon,       ellipsis,           division            ]};
    key <AB10>	{[ minus,      underscore,  endash,             emdash              ]};

    include "level3(ralt_switch)"
};
```
