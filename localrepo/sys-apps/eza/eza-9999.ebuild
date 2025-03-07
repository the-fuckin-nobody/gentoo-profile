# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo shell-completion git-r3

# script to generate the tarball: https://raw.githubusercontent.com/sevz17/eza-manpages/main/generate-eza-manpages
MANPAGES_BASE_URI="https://github.com/sevz17/eza-manpages/releases/download/0.20.8"

DESCRIPTION="A modern, maintained replacement for ls"
HOMEPAGE="https://eza.rocks https://github.com/eza-community/eza"
EGIT_REPO_URI="https://github.com/eza-community/eza.git"

LICENSE="EUPL-1.2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+git"

DEPEND="git? ( dev-libs/libgit2 )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_prepare() {
	default
	# Known failing tests, upstream says they could potentially be ignored for now.
	# bug #914214
	# https://github.com/eza-community/eza/issues/393
	rm tests/cmd/{icons,basic}_all.toml || die
	rm tests/cmd/absolute{,_recurse}_unix.toml || die

	sed -i -e 's/^strip = true$/strip = false/g' Cargo.toml || die "failed to disable stripping"
}

src_configure() {
	local myfeatures=(
		$(usev git)
	)
	export LIBGIT2_NO_VENDOR=0
	export PKG_CONFIG_ALLOW_CROSS=1
	cargo_src_configure --no-default-features --frozen
}

src_install() {
	cargo_src_install

	dobashcomp "completions/bash/${PN}"
	dozshcomp "completions/zsh/_${PN}"
	dofishcomp "completions/fish/${PN}.fish"
	dodoc -r "${WORKDIR}"/"${P}"/man/*
}
