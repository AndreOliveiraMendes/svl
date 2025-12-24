#!/usr/bin/env bash
set -e

PKG=svl
VERSION=$(grep '^SVL_VERSION=' $PKG.sh | cut -d'"' -f2)
DEST=pkg/$PKG
CAT=1

sed -i '1s/svl \([0-9]\+\.[0-9]\+\.[0-9]\+\)/svl '"$VERSION"'/g' man/$PKG.$CAT

rm -rf pkg
mkdir -p "$DEST"

# bin
install -Dm755 *.sh \
  "$DEST/data/data/com.termux/files/usr/bin/$PKG"

# libs
mkdir -p "$DEST/data/data/com.termux/files/usr/lib/$PKG/"
install -Dm644 lib/*.sh \
  "$DEST/data/data/com.termux/files/usr/lib/$PKG/"

# completion
install -Dm644 completions/*.bash \
  "$DEST/data/data/com.termux/files/usr/etc/bash_completion.d/$PKG"

# man
install -Dm644 man/*.$CAT \
  "$DEST/data/data/com.termux/files/usr/share/man/man$CAT/$PKG.$CAT"

# control
cat > control <<EOF
Package: ${PKG}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: all
Depends: bash, runit, dpkg
Maintainer: André Oliveira Mendes
Description: Simple runit service helper for Termux
 A small wrapper around sv(8) to list services, show status,
 and identify which package provides each service.
EOF

install -Dm644 control \
  "$DEST/DEBIAN/control"

chmod 755 "$DEST/DEBIAN"

rm control

dpkg-deb --build "$DEST"

