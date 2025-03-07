# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 udev

DESCRIPTION="Read and control brightness levels of devices"
HOMEPAGE="https://github.com/Hummer12007/brightnessctl"
EGIT_REPO_URI="https://github.com/Hummer12007/brightnessctl"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd udev"
REQUIRED_USE="systemd? ( !udev )"

DEPEND="
	systemd? ( sys-apps/systemd )
	udev? ( virtual/udev )
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

src_configure() {
	./configure --udev-dir=/usr/lib/udev/rules.d --prefix=/usr
}

src_compile() {
	local myconf
	if use systemd && use udev; then
		myconf="INSTALL_UDEV_RULES=0"
	elif use udev; then
		myconf="INSTALL_UDEV_RULES=1"
	else
		myconf="INSTALL_UDEV_RULES=0"
	fi

	emake ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README.md
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
