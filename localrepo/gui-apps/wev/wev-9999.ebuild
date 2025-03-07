# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 toolchain-funcs

DESCRIPTION="Wayland Event Debugger"
HOMEPAGE="https://git.sr.ht/~sircmpwn/wev"
EGIT_REPO_URI="https://git.sr.ht/~sircmpwn/wev"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/wayland
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/scdoc
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_prepare() {
	default
}

src_compile() {
	tc-export CC
	emake all
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
}
