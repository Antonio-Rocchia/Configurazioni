# Fonts

## Installing fonts per user
[archwiki: fonts](https://wiki.archlinux.org/title/Fonts)
- For a single user, install fonts to ~/.local/share/fonts/.
    - In many cases this suffices, unless you run graphical applications as other users.
    - In the past ~/.fonts/ was used, but is now deprecated.
- For system-wide (all users) installation, place your fonts under /usr/local/share/fonts/.
    - You may need to create the directory first: mkdir -p /usr/local/share/fonts.
    - /usr/share/fonts/ is under the purview of the package manager, and should not be modified manually.
```
~/.local/share/fonts/
├── otf
│   └── SourceCodeVariable
│       ├── SourceCodeVariable-Italic.otf
│       └── SourceCodeVariable-Roman.otf
└── ttf
    ├── AnonymousPro
    │   ├── Anonymous-Pro-B.ttf
    │   ├── Anonymous-Pro-I.ttf
    │   └── Anonymous-Pro.ttf
    └── CascadiaCode
        ├── CascadiaCode-Bold.ttf
        ├── CascadiaCode-Light.ttf
        └── CascadiaCode-Regular.ttf
```


## Display emojis in the terminal emulator
[archwiki: font configuration](https://wiki.archlinux.org/title/Font_configuration)
> Configuration can be done per-user through $XDG_CONFIG_HOME/fontconfig/fonts.conf (usually $HOME/.config/fontconfig/fonts.conf), and globally with /etc/fonts/local.conf. The settings in the per-user configuration have precedence over the global configuration. Both these files use the same syntax. 

> Fontconfig configuration files use XML format and need these headers: 
```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>

  <!-- settings go here -->

</fontconfig>
```

> An alternate approach is to use <alias> to set the "preferred" font. Fonts matching the <family> element are edited to prepend the list of <prefer>ed families before the matching <family>.
> <alias> can also be used to specify fallback fonts when some glyphs are missing.
```xml
  <alias>
    <family>RobotoMono Nerd Font Emoji alias</family>
    <prefer>
      <family>RobotoMono Nerd Font</family>
      <family>Noto Color Emoji</family>
     </prefer>
  </alias>
```


## Difference between RobotoMono NF and RobotoMono NF Mono
[github issue #830](https://github.com/ryanoasis/nerd-fonts/issues/597)
> Examined this after creating #830
> In Roboto there are some 'special' glyphs that are 'wider than normal' in the original font.
> These are for example Eth Ð , Dcroat ď and ldot ŀ.
> The Nerd Font Mono variant takes the widest glyph and makes the font 'really monospaced', thus it needs to increase the 'normal' glyph's width.
> We could exclude these specific glyphs, like in #830, but it is not so obvious if that is the right thing to do.
