#!/bin/bash -e

function die {
    printf "\x1b[91merror: %s\x1b[39m\n" "$@" >&2
    exit 99
}

function info {
    printf "\x1b[93m%s\x1b[39m\n" "$@" >&2
}

if [ ! -e ../void-packages ]; then
    die "../void-packages repo not found"
fi

if [ ! -e ../void-packages/srcpkgs ]; then
    die "../void-packages/src repo not found"
fi

if [ ! -e ../void-packages/common/build-style/haskell-cabal.sh ]; then
    info "Installing haskell-cabal build style"
    cp haskell-cabal.sh ../void-packages/common/build-style/.
fi

for thing in ./srcpkgs/*; do
    PKG=$(basename "${thing}")
    ROOT="../void-packages/srcpkgs/$PKG"
    if [ -e "$ROOT" ]; then
        if ( cd "$ROOT" && git ls-files --error-unmatch "template" >/dev/null 2>&1 ); then
            info "$PKG already exists in void-packages repo!"
        elif ! diff "srcpkgs/$PKG/template" "$ROOT/template" >/dev/null; then
            info "Package $PKG has modifications in void-packages"
        fi
    else
        mkdir -p "$ROOT"
        cp "srcpkgs/$PKG/template" "$ROOT/template"
    fi
done
