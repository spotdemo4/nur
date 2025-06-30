#!/usr/bin/env bash

SYSTEM=$(nix eval --impure --raw --expr 'builtins.currentSystem')
PKGSTR=$(nix eval --raw .\#packages."$SYSTEM" --apply 'attrs: builtins.toString (builtins.attrNames attrs)')
PKGS=( $PKGSTR )

for pkg in "${PKGS[@]}"; do
    echo "Updating" $pkg "..."
    eval nix-update $pkg --build --commit
    echo "Successfully updated" $pkg"."
done
