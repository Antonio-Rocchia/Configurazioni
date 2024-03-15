all:
	cat README.md | less

.PHONY: config-stow
.PHONY: config-unstow
.PHONY: config-restow

stow_packages = $(wildcard */)

config-stow:
	stow --verbose --target $(HOME) --stow $(stow_packages)

config-unstow:
	stow --verbose --target $(HOME) --delete $(stow_packages)

config-restow:
	stow --verbose --target $(HOME) --restow $(stow_packages)


.PHONY: _dnf-ensure-installed
.PHONY: _dnf-install-neovim
.PHONY: _dnf-setup-all

_dnf-ensure-installed:
	sudo dnf install --assumeyes \
		curl \
		git \
		gh \
		flatpak \
		bat \
		stow

_dnf-install-neovim:
	sudo dnf install --assumeyes \
		neovim \
		g++ \
		ripgrep \
		fd-find \
		fzf

_dnf-setup-all: _dnf-ensure-installed _dnf-install-neovim
	sudo dnf install --assumeyes \
		alacritty

.PHONY: _flatpak-install
.PHONY: _flatpak-install-gnome

_flatpak-install:
	flatpak install --assumeyes --noninteractive \
		com.discordapp.Discord \
		com.spotify.Client \
		com.github.tchx84.Flatseal \
		org.gimp.GIMP

_flatpak-install-gnome: flatpak-install
	flatpak install \
		org.gnome.Extensions

.PHONY: fedora-setup
.PHONY: fedora-setup-gnome

fedora-setup-generic: _dnf-setup-all _flatpak-install

fedora-setup-gnome: fedora-setup _flatpak-install-gnome
