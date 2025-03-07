# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo shell-completion git-r3

DESCRIPTION="cat(1) clone with syntax highlighting and Git integration"
HOMEPAGE="https://github.com/sharkdp/bat"
EGIT_REPO_URI="https://github.com/sharkdp/bat"

LICENSE="|| ( MIT Apache-2.0 )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD LGPL-3+ MIT Unicode-DFS-2016
	|| ( CC0-1.0 MIT-0 )
"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~mips ppc64 ~riscv ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/libgit2-1.7.0:=[threads]
	dev-libs/oniguruma:=
	sys-libs/zlib
"
# >app-backup/bacula-9.2[qt5] has file collisions, #686118
RDEPEND="${DEPEND}
	!>app-backup/bacula-9.2[qt5]
"

DOCS=( README.md CHANGELOG.md doc/alternatives.md )

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

# src_prepare() {
# 	# libgit2-sys unnecessarily(?) requests <libgit2-1.8.0, bump to 2 for now
# 	sed -e '/range_version/s/1\.8\.0/2/' \
# 		-i "${ECARGO_VENDOR}"/libgit2-sys-0.16.1+1.7.1/build.rs || die
# }

src_configure() {
	export RUSTONIG_SYSTEM_LIBONIG=1
	export PKG_CONFIG_ALLOW_CROSS=1
	sed -i -e 's/strip = true/strip = false/g' Cargo.toml || die
	cargo_src_configure --frozen
}

src_test() {
	# Set COLUMNS for deterministic help output, #913364
	local -x COLUMNS=100

	cargo_src_test
}

src_install() {
	cargo_src_install

	einstalldocs

	local build_dir=( "$(cargo_target_dir)"/build/${PN}-*/out )
	cd "${build_dir[0]}" || die "Cannot change directory to ${PN} build"

	doman assets/manual/bat.1

	newbashcomp assets/completions/${PN}.bash ${PN}
	newzshcomp assets/completions/${PN}.zsh _${PN}
	dofishcomp assets/completions/${PN}.fish
}
