# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, feature-rich, and cross-platform terminal emulator"
HOMEPAGE="https://ghostty.org/"

ZIG_SLOT="0.13"

inherit zig git-r3

EGIT_REPO_URI="https://github.com/ghostty-org/ghostty.git"

LICENSE="Apache-2.0 BSD BSD-2 BSD-4 Boost-1.0 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-libs/ncurses"
BDEPEND="sys-libs/ncurses"

PATCHES=(
	"${FILESDIR}"/${PN}-build-add-a-step-for-only-building-terminfo.patch
)

src_unpack() {
	git-r3_src_unpack
	echo "----------------------------------------------------Debug------------------------------------------------"
	echo "${S}"
	echo "----------------------------------------------------Debug------------------------------------------------"
	zig_live_fetch
	echo "----------------------------------------------------Debug------------------------------------------------"
}

src_configure() {
	echo "----------------------------------------------------Debug------------------------------------------------"
	echo "In configure phase"
	echo "----------------------------------------------------Debug------------------------------------------------"
	local my_zbs_args=(
		-Demit-terminfo=false
		-Demit-termcap=false
	)
	zig_src_configure
}

src_compile() {
	:
}

src_install() {
	DESTDIR="${D}" nonfatal ezig build terminfo "${ZBS_ARGS[@]}" \
		|| die "Failed to compile terminfo database"
}
