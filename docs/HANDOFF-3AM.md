# Handoff — KNOBController (para el agente de las 3 AM)

## Estado: app 100% funcional y desplegada, repo público, primer release.

### Hecho esta noche
1. **Música de sueño (8h)** — radio-sleep.service en la VAIO reproduce
   "Driving San Diego at Night 8K" y otros 5 videos de ambiente nocturno en
   bucle (40 min c/u). Suena en el Ático (sink BT #96, RUNNING). Para parar:
   `ssh vaio "systemctl --user stop radio-sleep.service"`.
2. **Backend nuevo** (`/usr/local/bin/knob-controller`, fuente en
   `/mnt/sda1/projects/knob-controller/backend/knob-controller`):
   - 5 modos: scroll, volume, text, **brightness**, **zoom**
   - Shortcuts por modificador (Alt=cambiar app, Ctrl=paneles)
   - **Shortcuts de comando** (ejecuta cualquier shell)
   - **Captura de teclas** (`POST /api/capture` + eventos SSE)
   - API: `/api/shortcut-add`, `/api/shortcut-delete`, `/api/shortcut-enabled`
3. **App nativa** (`/usr/local/bin/knob-controller-native`): 5 botones de modo
   + panel de shortcuts con toggle y soporte de comandos.
4. **GitHub**: repo público `mrallanodreman/KNOBController`, release v1.0.0
   con tarball fuente. README + icono EMA + licencia MIT.
5. **Packaging**: manifests Flatpak/Snap/AUR + script `scripts/build-release.sh`
   (genera tarball y .deb).

### Para verificar en vivo
```bash
systemctl is-active knob-controller.service   # active
curl -s http://127.0.0.1:8766/api/status       # modes incl. brightness/zoom
# Reabrir app nativa:
/usr/local/bin/knob-controller-native-open
```

### Pendiente para el otro agente (requiere cuentas del dueño)
- itch.io / Snapcraft / Flathub / AUR / SourceForge → ver `docs/PUBLISHING.md`
- **NO piratear ni saltar pagos.** Steam/Apple/Microsoft cobran y requieren
  identidad; no automatizable sin credenciales del dueño.
- El backend original de la app nativa usaba `/api/click-map` (CLICK_LABELS)
  que ya NO existe en el backend nuevo (el clic ahora alterna modos). Si la
  app nativa pide click-keys, revisar compatibilidad.
- `docs/PUBLISHING.md` detalla la advertencia de sandbox: `/dev/uinput` +
  `EVIOCGRAB` complican Flathub/Snap estrictos.

### Rutas clave
- Proyecto: `/mnt/sda1/projects/knob-controller/`
- Backend instalado: `/usr/local/bin/knob-controller`
- App nativa instalada: `/usr/local/bin/knob-controller-native`
- Config: `/etc/knob-controller/config.json`
- GitHub: https://github.com/mrallanodreman/KNOBController

### Nota de seguridad de la casa
El knob cierra limpio: en modo volume al cerrar se para el servicio y el knob
vuelve a volumen nativo. En scroll queda solo el agente mínimo.
