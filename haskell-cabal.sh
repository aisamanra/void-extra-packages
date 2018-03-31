#
# This helper is for templates built using Haskell cabal.
do_build() {
	cabal sandbox init
	cabal update
	cabal install ${makejobs} --only-dependencies
	cabal configure -v --prefix=/usr --libsubdir='$pkg' \
		--datasubdir='$pkg' --docdir='$datadir/doc/$pkg'
	cabal build ${makejobs}
}

do_install() {
	vbin dist/build/${pkgname}/${pkgname}
	if [ -e LICENSE ]; then
		vlicense LICENSE
	fi
}
