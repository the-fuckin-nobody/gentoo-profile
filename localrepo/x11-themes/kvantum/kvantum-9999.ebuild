# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# taken from Kvantum/style/CMakeLists.txt
QTMIN="6.2.0"
KFMIN="6.0.0"
inherit cmake multibuild xdg git-r3

DESCRIPTION="SVG-based theme engine for Qt, KDE Plasma and LXQt"
HOMEPAGE="https://github.com/tsujan/Kvantum"
EGIT_REPO_URI="https://github.com/tsujan/Kvantum"
S=${S}/${PN^}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="kde qt5"

RESTRICT="test" # no tests

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,X]
	>=dev-qt/qtsvg-${QTMIN}:6
	x11-libs/libX11
	kde? ( >=kde-frameworks/kwindowsystem-${KFMIN}:6 )
	qt5? (
		>=dev-qt/qtcore-5.15.9:5
		>=dev-qt/qtgui-5.15.9:5
		>=dev-qt/qtsvg-5.15.9:5
		>=dev-qt/qtwidgets-5.15.9:5
		>=dev-qt/qtx11extras-5.15.9:5
		kde? ( >=kde-frameworks/kwindowsystem-5.115.0:5 )
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	qt5? ( dev-qt/linguist-tools:5 )
"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) qt6 )
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			-DENABLE_QT4=OFF
		)
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=(
				-DENABLE_QT5=ON
				-DWITHOUT_KF=$(usex !kde)
			)
		elif [[ ${MULTIBUILD_VARIANT} = qt6 ]]; then
			mycmakeargs+=(
				-DENABLE_QT5=OFF
				-DWITHOUT_KF=$(usex !kde)
			)
		fi
		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
