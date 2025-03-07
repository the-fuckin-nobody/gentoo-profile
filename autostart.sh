#! /usr/bin/env bash

set_bg() {
	WALLPAPER=$(cat ~/.local/share/wallpapers/last_changed_wallpaper)
	pgrep -x wbg || wbg -s "$WALLPAPER"
}

apply_gtk_settings() {
	gsettings set org.gnome.desktop.interface gtk-theme "Colloid-Dark-Tokyonight" 
	gsettings set org.gnome.desktop.interface font-name "Titillium Web 10"
	gsettings set org.gnome.desktop.interface icon-theme "Qogir-dark"
	gsettings set org.gnome.desktop.interface cursor-size "24"
	gsettings set org.gnome.desktop.interface cursor-theme "Future-cursors"
	gsettings set org.gnome.desktop.interface cursor-blink true
	gsettings set org.gnome.desktop.interface monospace-font-name "Lotion Nerd Font Propo 10"
	gsettings set org.gnome.desktop.interface document-font-name "Jost 10"
	gsettings set org.gnome.desktop.interface enable-animations true
	gsettings set org.gnome.desktop.wm.preferences theme "Colloid-Dark-Tokyonight"
}

main() {
	set_bg
	apply_gtk_settings
}

main
