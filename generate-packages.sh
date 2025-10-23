#!/bin/bash
set -e
cd "$(dirname "$0")"

AUR_DIR="aur"

handle_PKGBUILD() {
    echo "  > PKGBUILD"
    local dir=$1
    if ! test -d "../$AUR_DIR/$dir"; then
        echo "      > $dir does not exist"
        return
    fi
    cp -f "$dir/PKGBUILD" "../$AUR_DIR/$dir/PKGBUILD"
    echo "      > Copied PKGBUILD"
    cd "../$AUR_DIR/$dir/"
    makepkg --printsrcinfo PKGBUILD > .SRCINFO
    echo "      > Generated SRCINFO"
    cd - > /dev/null
}

for dir in */; do
    dir="${dir%/}"
    echo -e "\e[34mProcessing: $dir\e[0m"

    for file in $dir/*; do
        case $file in
            */PKGBUILD)
                handle_PKGBUILD $dir
                ;;
        esac
    done
done
