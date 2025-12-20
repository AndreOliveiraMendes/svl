#!/usr/bin/env bash
set -e

PKG=svl
VERSION=$(grep '^SVL_VERSION=' svl.sh | cut -d'"' -f2)
DEST=pkg/$PKG

rm -rf pkg
mkdir -p "$DEST"

# bin
install -Dm755 svl.sh \
  "$DEST/data/data/com.termux/files/usr/bin/svl"

# libs
mkdir -p "$DEST/data/data/com.termux/files/usr/lib/svl/"
install -Dm644 lib/*.sh \
  "$DEST/data/data/com.termux/files/usr/lib/svl/"

# completion
install -Dm644 completions/svl.bash \
  "$DEST/data/data/com.termux/files/usr/etc/bash_completion.d/svl"

# man
install -Dm644 man/svl.1 \
  "$DEST/data/data/com.termux/files/usr/share/man/man1/svl.1"

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

