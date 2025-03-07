# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Hyprland graphics / resource utilities"
HOMEPAGE="https://github.com/hyprwm/hyprgraphics"
EGIT_REPO_URI="https://github.com/hyprwm/hyprgraphics"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=gui-libs/hyprutils-0.1.1:=
	media-libs/libjpeg-turbo:=
	media-libs/libjxl:=
	media-libs/libwebp:=
	media-libs/libspng
	sys-apps/file
	x11-libs/cairo
"
DEPEND="${RDEPEND}"
