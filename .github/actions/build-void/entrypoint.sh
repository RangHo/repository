#!/bin/sh

set -eu

SRCPKGS="$1"
PKGNAME="$2"

# Set up XBPS.
xbps-install -Sy
xbps-install -yu xbps
xbps-install -yu

# Install git and download Void package repository.
xbps-install -y git
git clone --depth=1 https://github.com/void-linux/void-packages

# Change directory to void-packages.
cd void-packages

# Copy all custom srcpkgs.
for pkg in "${GITHUB_WORKSPACE}/${SRCPKGS}"/*; do
    name=$(basename "${pkg}")
    rm -rf "./srcpkgs/${name}"
    cp -r "${pkg}" "./srcpkgs/${name}"
    if [ -f "${pkg}/shlib" ]; then
        cat "${pkg}/shlib" >> common/shlibs
    fi
done

# Configure xbps-src.
cat <<EOF >./etc/conf
XBPS_ALLOW_CHROOT_BREAKOUT=yes
XBPS_ALLOW_RESTRICTED=yes
XBPS_CHROOT_CMD=ethereal
XBPS_MIRROR=https://repo-fastly.voidlinux.org/current
EOF
ln -s / ./masterdir

# Build the package.
./xbps-src pkg "${PKGNAME}"

# Move the built package back to workspace.
version="$(./xbps-src -a x86_64 show "${PKGNAME}" | grep '^version' | sed 's/\t//' | cut -d ':' -f 2)"
revision="$(./xbps-src -a x86_64 show "${PKGNAME}" | grep '^revision' | sed 's/\t//' | cut -d ':' -f 2)"
arch="$(uname -m)"
pkgfile="${PKGNAME}-${version}_${revision}.${arch}.xbps"
find ./hostdir/binpkgs -name "${pkgfile}" -exec mv {} "${GITHUB_WORKSPACE}/${pkgfile}" \;

# Check if package actually exists.
[ -f "${GITHUB_WORKSPACE}/${pkgfile}" ]

# Set output.
echo "pkgfile=${pkgfile}" >> $GITHUB_OUTPUT