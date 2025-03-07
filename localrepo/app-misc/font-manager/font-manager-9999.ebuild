# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala git-r3
EGIT_REPO_URI="https://github.com/FontManager/font-manager.git"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="A simple font management application for Gtk+ Desktop Environments"
HOMEPAGE="https://fontmanager.github.io"

VALA_MIN_API_VERSION=0.56
VALA_USE_DEPEND="vapigen"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc gnome-search-provider google-fonts +manager nautilus nemo reproducible thunar +viewer +nls"

RDEPEND="gnome-base/gnome-common
>=dev-db/sqlite-3.8
>=dev-libs/json-glib-0.15
>=dev-libs/libxml2-2.9
>=media-libs/fontconfig-2.1
>=media-libs/freetype-2.5
>=x11-libs/gtk+-3.22
>=x11-libs/pango-1.4
google-fonts? (
>=net-libs/libsoup-2.62
>=net-libs/webkit-gtk-2.24
)
nautilus? ( gnome-base/nautilus )
nemo? ( gnome-extra/nemo )
thunar? ( xfce-base/thunar )
"

DEPEND="${RDEPEND}
$(vala_depend)
doc? (
app-text/yelp-tools
dev-util/gtk-doc
)
"

src_prepare() {
	default
	vala_setup
	gnome2_src_prepare
}

src_configure() {
	# export VALAC="/usr/bin/valac-0.56"
	# export VAPIGEN="/usr/bin/vapigen-0.56"
	meson_src_configure \
		$(meson_use manager) \
		$(meson_use viewer) \
		$(meson_use reproducible) \
		$(meson_use nautilus) \
		$(meson_use nemo) \
		$(meson_use thunar) \
		$(meson_use gnome-search-provider search-provider) \
		$(meson_use google-fonts webkit) \
		$(meson_use nls enable-nls) \
		$(meson_use doc yelp-doc) \
		$(meson_use doc gtk-doc)
	}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
