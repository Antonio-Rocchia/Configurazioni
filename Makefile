all:
	cat README.md | less

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
		flatpak \
		pipewire \
		pipewire-plugin-libcamera \
		make 

_dnf-install-neovim-deps:
	sudo dnf install --assumeyes \
		neovim \
		g++ \
		cmake \
		ripgrep \
		fd-find \
		fzf

_dnf-setup-all: _dnf-ensure-installed _dnf-install-neovim-deps
	sudo dnf install --assumeyes \
		alacritty \
		gh \
		bat \
		stow \
		default-fonts \

#####################
# (PRIVATE) FLATPAK
#	Install and remove software using flatpak
#####################
.PHONY: _flatpak-install
.PHONY: _flatpak-install-gnome

_flatpak-install:
	flatpak remote-add --if-not-exists --prio=2 --subset=verified flathub-verified https://flathub.org/repo/flathub.flatpakrepo
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install --assumeyes --noninteractive io.github.spacingbat3.webcord
	flatpak install --assumeyes --noninteractive com.spotify.Client 
	flatpak install --assumeyes --noninteractive com.github.tchx84.Flatseal 
	flatpak install --assumeyes --noninteractive org.gimp.GIMP 
	flatpak install --assumeyes --noninteractive org.gnome.World.PikaBackup
	flatpak install --assumeyes --noninteractive org.mozilla.firefox
	flatpak install --assumeyes --noninteractive org.gnome.Evince

_flatpak-install-gnome: flatpak-install
	flatpak install --assumeyes --noninteractive org.gnome.Extensions

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
.PHONY: setup-fedora-minimal

setup-fedora-generic: _dnf-setup-all _flatpak-install

setup-fedora-gnome: setup-fedora-generic _flatpak-install-gnome

setup-fedora-hyprland: _dnf-setup-all _flatpak-install
	sudo dnf install --assumeyes \
		xdg-utils \
		xdg-user-dirs \
		cmake \
		meson \
		dunst \
		polkit-kde \
		hyprland \
		sddm \
		default-fonts \
		kanshi \
		waybar \
		pavucontrol
	systemctl --user --now enable pipewire
	systemctl --user --now enable pipewire-pulse.service
	systemctl --user --now enable wireplumber
	sudo systemctl set-default graphical.target
	sudo systemctl enable sddm
	grep 'ExecStart=' /etc/systemd/system/display-manager.service

