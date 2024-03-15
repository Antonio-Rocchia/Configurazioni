all:
	cat README.md | less

#####################
# CONFIG
#	Manage dotiles using stow
#####################
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


#####################
# (PRIVATE) PACKAGE MANAGERS
## (PRIVATE) DNF
#	Install and remove software using a specific package manager
#####################
.PHONY: _dnf-ensure-installed
.PHONY: _dnf-install-neovim-deps
.PHONY: _dnf-setup-all

_dnf-ensure-installed:
	sudo dnf install --assumeyes \
		curl \
		git \
		gh \
		flatpak \
		bat \
		stow

_dnf-install-neovim-deps:
	sudo dnf install --assumeyes \
		neovim \
		g++ \
		ripgrep \
		fd-find \
		fzf

_dnf-setup-all: _dnf-ensure-installed _dnf-install-neovim
	sudo dnf install --assumeyes \
		alacritty

#####################
# (PRIVATE) FLATPAK
#	Install and remove software using flatpak
#####################
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

#####################
# FILESYSTEM
#	Create and delete folders
#####################
.PHONY: fs-create-all
.PHONY: fs-clean-esperimenti

fs-create-all: 
	mkdir -p $(HOME)/Eseguibili \
		$(HOME)/Sviluppo/{Codice,Strumenti} \
		$(HOME)/Sviluppo/Codice/{Esperimenti,Progetti}

fs-clean-esperimenti:
	rm -rf $(HOME)/Sviluppo/Codice/Esperimenti/*


#####################
# SETUP
#	Bootstrap the configuration of various OS using other targets
#####################
.PHONY: setup-fedora-generic
.PHONY: setup-fedora-gnome

setup-fedora-generic: _dnf-setup-all _flatpak-install

setup-fedora-gnome: setup-fedora-generic _flatpak-install-gnome
