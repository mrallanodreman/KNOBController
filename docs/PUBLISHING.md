# Publicación en tiendas — KNOBController

Todo lo que requiere una cuenta tuya / del otro agente. GitHub ya está hecho
(`https://github.com/mrallanodreman/KNOBController`, release `v1.0.0`).

**Regla ética:** ningún paso requiere "piratear" ni saltar un pago. Todo lo
gratuito es gratis de verdad. Steam/Microsoft/Apple cobran y necesitan tu
cuenta con verificación de identidad — no se intenta evadir eso.

---

## 1. GitHub ✅ (HECHO)
- Repo público: https://github.com/mrallanodreman/KNOBController
- Release v1.0.0 con `knob-controller-1.0.0.tar.gz`
- Branding: README.md + assets/icon (svg + png 256)

## 2. itch.io (gratis, sin coste) — requiere tu cuenta
```bash
# Instalar butler (CLI oficial de itch.io)
curl -sL https://broth.itch.ovh/butler/install-linux-64.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# Login (abre navegador, autenticación tuya)
butler login

# Publicar el tarball como build de Linux (puede subir el binario nativo)
butler push dist/knob-controller-1.0.0.tar.gz mrallanodreman/knob-controller:linux
```
- Precio: lo pones tú en la web de itch.io (el dueño quiere $1).
- Cover: usa `assets/knob-controller.png` / `icon.svg`.

## 3. Flathub (gratis) — requiere PR al repo oficial
- Manifiesto listo: `packaging/flatpak/art.edgemarketing.KNOBController.yaml`
- Pasos: hacer fork de `github.com/flathub/flathub`, añadir el manifest, abrir
  PR. El review de Flathub revisa que el app no use `--device=all` de más ni
  comandos shell (probablemente haya que rehacer el backend para sandbox,
  ya que necesita `/dev/uinput` — eso requiere `--device=all`).
  ⚠️ Es probable que Flathub rechace el `EVIOCGRAB` por sandbox. Alternativa:
  publicar en GitHub Releases + AUR y no en Flathub.

## 4. Snap (gratis) — requiere cuenta Snapcraft
```bash
# snapcraft.yaml ya está en packaging/snap/
snapcraft login        # tu cuenta
snapcraft build        # en un entorno con snap
snapcraft upload dist/knob-controller_*.snap --release=stable
```
⚠️ Mismo problema de sandbox: strict confinement no deja `/dev/uinput`.
Usar `confinement: devmode` para primera versión.

## 5. AUR (gratis, Arch) — requiere cuenta AUR + SSH key
- `packaging/aur/PKGBUILD` listo (falta el checksum real).
- El ecosistema del dueño es Arch/CachyOS, así que este es el público natural.
- Pasos: `makepkg`, luego `git push` a tu repo AUR.

## 6. Steam / Microsoft / Apple — PAGO + identidad (NO automatizable aquí)
- Steam: $100 Greenlight / Steamworks + verificación de identidad.
- Apple: $99/año desarrollador + macOS para firmar.
- Microsoft: $19 cuenta desarrollador.
- Requieren DNI/impuestos/tu cuenta personal. No los hago sin tus credenciales.
- El scaffold Tauri (`native-app/tauri`) está pensado para esto a futuro.

## 7. SourceForge (gratis) — requiere cuenta
- Subir `dist/knob-controller-1.0.0.tar.gz` desde la web.
- No hay API de subida automática sin token.

---

## Recomendación de prioridad (todo gratis, en orden)
1. **GitHub** ✅ hecho
2. **AUR** — público Arch/CachyOS, encaja con el hardware del dueño
3. **itch.io** — fácil, sube build, perfecto para el modelo "$1"
4. **SourceForge** — archivo universal
5. **Snap** (devmode) — si el sandbox lo permite
6. **Flathub** — probablemente bloquee por `/dev/uinput`

**No se piratea, no se salta el pago, no se falsifica identidad.**
