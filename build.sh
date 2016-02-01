#!/bin/sh

set -eux

OUTDIR=/output

main() {
    # Set up abuild
    if ! grep -q '^PACKAGER' /etc/abuild.conf ; then
        echo 'PACKAGER="Andrew Dunham <andrew@du.nham.ca>"' | sudo tee -a /etc/abuild.conf
        echo 'MAINTAINER="$PACKAGER"' | sudo tee -a /etc/abuild.conf
    fi

    # Clone package repo
    cd "$HOME"
    if [ ! -d aports ]; then
        git clone --depth 1 git://dev.alpinelinux.org/aports
    fi

    # Generate a package signing key
    abuild-keygen -a -i -n

    # Patch our APKBUILD
    cd "$HOME"/aports/main/nginx
    for i in `ls $HOME | sort`; do
        case $i in
            *.patch)
                echo "Applying patch: $i"
                patch -p1 --ignore-whitespace -i "$HOME"/$i || return 1
                ;;
        esac
    done

    # Make a link to our output
    mkdir -p "$OUTDIR"/packages
    ln -s "$OUTDIR"/packages "$HOME"/packages

    # Run the build.  Useful options could be:
    #   -r      Run recursively
    #   -f      Force run (even if everything is up-to-date)
    abuild "$@"
}

main "$@"
