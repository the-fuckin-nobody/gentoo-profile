# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cargo
DESCRIPTION="Blazingly fast interpolated LUT generator and applicator for arbitrary and popular color palettes."
HOMEPAGE="https://github.com/ozwaldorf/lutgen-rs"
EGIT_REPO_URI="https://github.com/ozwaldorf/lutgen-rs"

LICENSE="GPL-3+"
LICENSE+="
Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC MIT MPL-2.0
	Unicode-3.0 Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
DOCS=(
	README.md
)

QA_FLAGS_IGNORED="/usr/bin/${PN}"

pkg_setup() {
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
	cargo_src_configure --no-default-features --frozen --features=bin
}

src_install() {
	cargo_src_install
}
