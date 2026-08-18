#!/usr/bin/env bash
# KNOBController — build de artefactos para distribución.
# Genera tarball fuente, .deb y paquete Flatpak, listos para publicar.
set -euo pipefail

VERSION="${1:-1.0.0}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIST="$ROOT/dist"
mkdir -p "$DIST"

echo "==> Limpiando artefactos previos"
rm -rf "$DIST"/knob-controller-* "$DIST"/*.deb "$DIST"/*.tar.*

echo "==> Tarball fuente ($VERSION)"
tar --exclude='*.pyc' --exclude='__pycache__' --exclude='.git' \
  -czf "$DIST/knob-controller-$VERSION.tar.gz" -C "$ROOT" \
  backend native-app assets packaging README.md LICENSE .gitignore
echo "   -> $DIST/knob-controller-$VERSION.tar.gz"

echo "==> Paquete .deb ($VERSION)"
DEBROOT="$DIST/debroot"
rm -rf "$DEBROOT"
mkdir -p "$DEBROOT/DEBIAN"
mkdir -p "$DEBROOT/usr/local/bin"
mkdir -p "$DEBROOT/usr/share/applications"
mkdir -p "$DEBROOT/usr/share/icons/hicolor/256x256/apps"
mkdir -p "$DEBROOT/usr/lib/systemd/system"

install -m755 "$ROOT/backend/knob-controller" "$DEBROOT/usr/local/bin/knob-controller"
install -m755 "$ROOT/native-app/knob-controller-native" "$DEBROOT/usr/local/bin/knob-controller-native"
install -m644 "$ROOT/packaging/knob-controller.desktop" "$DEBROOT/usr/share/applications/knob-controller.desktop"
install -m644 "$ROOT/assets/knob-controller.png" "$DEBROOT/usr/share/icons/hicolor/256x256/apps/knob-controller.png"
install -m644 "$ROOT/packaging/knob-controller.service" "$DEBROOT/usr/lib/systemd/system/knob-controller.service"

cat > "$DEBROOT/DEBIAN/control" <<EOF
Package: knob-controller
Version: $VERSION
Section: utils
Priority: optional
Architecture: all
Maintainer: Edge Marketing Agency <software@edgemarketing.art>
Depends: python3, python3-gi, gir1.2-gtk-3.0, python3-cairo, libevdev2
Description: Control your keyboard knob your way
 Scroll, volume, cursor, brightness, zoom, app switching, terminal panes
 or run any command from your keyboard's knob.
 Software libre by Edge Marketing Agency.
EOF

dpkg-deb --build --root-owner-group "$DEBROOT" "$DIST/knob-controller_${VERSION}_all.deb" >/dev/null
echo "   -> $DIST/knob-controller_${VERSION}_all.deb"

echo ""
echo "==> Listo. Artefactos en $DIST:"
ls -lh "$DIST"
echo ""
echo "==> Para publicar en tiendas:"
echo "  GitHub  : ya está en https://github.com/mrallanodreman/KNOBController"
echo "  itch.io : butler push $DIST/knob-controller-$VERSION.tar.gz mrallanodreman/knob-controller:linux"
echo "  Flatpak : PR a github.com/flathub (ver packaging/flatpak)"
echo "  AUR     : subir packaging/aur/PKGBUILD (necesita cuenta AUR)"
echo "  Snap    : snapcraft login && snapcraft push (necesita cuenta Snap)"