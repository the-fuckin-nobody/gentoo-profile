# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, feature-rich, and cross-platform terminal emulator"
HOMEPAGE="https://ghostty.org/"

ZIG_SLOT="0.13"

inherit zig xdg git-r3

EGIT_REPO_URI="https://github.com/ghostty-org/ghostty.git"

LICENSE="
	Apache-2.0 BSD BSD-2 BSD-4 Boost-1.0 MIT MPL-2.0
	!system-freetype? ( || ( FTL GPL-2+ ) )
	!system-harfbuzz? ( Old-MIT ISC icu )
	!system-libpng? ( libpng2 )
	!system-zlib? ( ZLIB )
"
SLOT="0"
KEYWORDS="~amd64"

# TODO: simdutf integration (missing Gentoo version)
# TODO: spirv-cross integration (missing Gentoo package)
# TODO: glfw integration (no option from upstream)
# NOTE: gtk backend requires X right now since ghostty unconditionally
#       includes gdk/x11/gdkx.h.
#       https://github.com/ghostty-org/ghostty/issues/3477
COMMON_DEPEND="
	>=dev-libs/oniguruma-6.9.9:=
	>=dev-util/glslang-1.3.296.0:=
	gui-libs/gtk:4=[X?]
	>=media-libs/fontconfig-2.14.2:=
	>=media-libs/freetype-2.13.2:=[bzip2,harfbuzz,png]
	>=media-libs/harfbuzz-8.4.0:=[truetype]
	X? ( x11-libs/libX11 )
	adwaita? ( gui-libs/libadwaita:1= )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="
	${COMMON_DEPEND}
	|| (
		>=sys-libs/ncurses-6.5_p20250118[-minimal]
		~x11-terms/ghostty-terminfo-${PV}
	)
"
BDEPEND="
	man? ( virtual/pandoc )
"

IUSE="+X +adwaita man"

# REQUIRED_USE="
# 	adwaita? ( gtk )
# 	^^ ( gtk glfw )
# "

# XXX: Because we set --release=fast below, Zig will automatically strip
#      the binary. Until Ghostty provides a way to disable the banner while
#      having debug symbols we have ignore pre-stripped file warnings.
QA_PRESTRIPPED="usr/bin/ghostty"

PATCHES=(
	"${FILESDIR}"/${PN}-build-disable-terminfo-database-installation.patch
	"${FILESDIR}"/${PN}-bzip2-dependency.patch
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
		local my_zbs_args=(
		# XXX: Ghostty displays a banner saying it is a debug build unless ReleaseFast is used.
		--release=fast

		-Dapp-runtime=gtk
		-Dfont-backend=fontconfig_freetype
		-Drenderer=opengl
		-Dgtk-adwaita=$(usex adwaita true false)
		-Dgtk-x11=$(usex X true false)
		-Demit-docs=$(usex man true false)
		-Dversion-string="${PV}"
		-Demit-terminfo=false
		-Demit-termcap=false

		-fsys=fontconfig
		-fsys=freetype
		-fsys=glslang
		-fsys=harfbuzz
		-fsys=libpng
		-fsys=oniguruma
		-fsys=zlib

		# See TODO above COMMON_DEPEND
		-fno-sys=simdutf
		-fno-sys=spirv-cross
	)
	zig_src_configure
}



src_install() {
	zig_src_install

	# HACK: Zig 0.13.0 build system's InstallDir step has a bug where it
	#       fails to install symbolic links, so we manually create it
	#       here.
	dosym -r /usr/share/terminfo/x/xterm-ghostty /usr/share/terminfo/g/ghostty
}
