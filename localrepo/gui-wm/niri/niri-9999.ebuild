# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LLVM_COMPAT=( {16..19} )

inherit cargo git-r3 llvm-r1
DESCRIPTION="A scrollable tiling Wayland compositor"
HOMEPAGE="https://www.github.com/YaLTeR/niri.git"
EGIT_REPO_URI="https://www.github.com/YaLTeR/niri.git"

LICENSE="GPL-3+"
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC MIT MPL-2.0
	Unicode-3.0 Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+wayland +dbus screencast systemd"
REQUIRED_USE="
	screencast? ( dbus )
	systemd? ( dbus )
"

DEPEND="
	dev-libs/glib:2
	dev-libs/libinput:=
	dev-libs/wayland
	media-libs/libdisplay-info:=
	media-libs/mesa
	sys-auth/seatd:=
	virtual/libudev:=
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	screencast? (
		media-video/pipewire
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	screencast? ( $(llvm_gen_dep 'llvm-core/clang:${LLVM_SLOT}') )
"

PATCHES=(
		"${FILESDIR}"/run-${PN}-with-dbus.patch
)
QA_FLAGS_IGNORED="/usr/bin/${PN}"

pkg_setup() {
	llvm-r1_pkg_setup
	rust_pkg_setup
}

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	default
}

src_configure() {
	local myfeatures=(
		$(usev dbus)
		$(usev screencast xdp-gnome-screencast)
		$(usev systemd)
	)
	cargo_src_configure --no-default-features --frozen
}

src_install() {
	cargo_src_install

	insinto /usr/share/wayland-sessions
	doins resources/niri.desktop

	insinto /usr/share/xdg-desktop-portal
	doins resources/niri-portals.conf
}
