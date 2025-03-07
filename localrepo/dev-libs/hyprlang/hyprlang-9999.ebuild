# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Official implementation library for the hypr config language"
HOMEPAGE="https://github.com/hyprwm/hyprlang"
EGIT_REPO_URI="https://github.com/hyprwm/hyprlang"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=gui-libs/hyprutils-0.1.1:="
DEPEND="${RDEPEND}"

