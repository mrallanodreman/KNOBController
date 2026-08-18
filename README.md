# KNOBController

**Tu knob, tus reglas.** Convierte el knob del teclado MEETION en el control más
poderoso de tu escritorio. Un giro, un gesto: apps, paneles de terminal, volumen,
brillo, zoom o cualquier comando.

```
Software libre · Edge Marketing Agency · edgemarketing.art
```

---

## ¿Qué hace?

El knob físico de tu teclado emite `VOL_UP` / `VOL_DOWN` y un clic. **KNOBController**
lo intercepta y lo remapea a lo que TÚ quieras:

| Gesto | Acción por defecto |
|---|---|
| Giro (sin mod) | **Scroll vertical** |
| **Alt** + giro | **Cambiar de aplicación** (Alt+Tab) |
| **Ctrl** + giro | **Paneles de terminal** (Ctrl+←/→) |
| Clic | Alterna scroll ↔ cursor de texto |

Y además: **brillo**, **zoom**, **volumen**, cursor de texto… o ejecuta
**cualquier comando** (abrir una app, un script, una web).

## Características

- 🎛 **5 modos de giro**: scroll, volumen, cursor, brillo, zoom
- ⌨️ **Shortcuts por modificador**: Alt, Ctrl, Shift + rueda
- ⚙️ **Ejecuta comandos**: mapea el knob a `xdg-open ...`, scripts, lo que sea
- 🎥 **Captura de teclas**: graba un gesto nuevo desde la UI, sin tocar código
- 🖥 **UI nativa GTK** + **UI web** en `http://127.0.0.1:8766`
- 🔧 **Configurable** en `/etc/knob-controller/config.json`
- 🌐 **Espía el teclado** para detectar modificadores, sin robarlo

## Instalación

```bash
sudo cp backend/knob-controller /usr/local/bin/knob-controller
sudo cp native-app/knob-controller-native /usr/local/bin/knob-controller-native
sudo chmod 755 /usr/local/bin/knob-controller*

# Servicio
sudo cp packaging/knob-controller.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now knob-controller.service

# App nativa
sudo cp packaging/knob-controller.desktop /usr/share/applications/
```

## Configuración

Todo vive en `/etc/knob-controller/config.json`. Un shortcut puede ser de tipo
`key` (emite teclas) o `command` (ejecuta un comando):

```json
{
  "mode": "scroll",
  "shortcuts": [
    {
      "id": "alt-apps",
      "name": "Cambiar de aplicación",
      "mods": ["alt"],
      "type": "key",
      "up": ["tab"], "down": ["tab"],
      "wrap": true, "enabled": true
    },
    {
      "id": "alt-term",
      "name": "Abrir terminal",
      "mods": ["alt"],
      "type": "command",
      "command": "xterm &"
    }
  ]
}
```

## Empaquetado y distribución

Preparado para distribución libre en:

- **Flatpak** → `packaging/flatpak/`
- **Snap** → `packaging/snap/`
- **AUR** → `packaging/aur/`
- **itch.io** → `packaging/itchio/`
- **SourceForge** → `packaging/sourceforge/`

## API HTTP (localhost:8766)

- `GET /api/status` — estado, modo, shortcuts
- `POST /api/mode` — cambiar modo de giro
- `POST /api/shortcut-add` — añadir shortcut
- `POST /api/shortcut-delete` — borrar shortcut
- `POST /api/capture` — entrar en modo captura
- `GET /events` — SSE en vivo

## Arquitectura

```
backend/knob-controller        → demonio: evdev/uinput + API HTTP + UI web
native-app/knob-controller-native → cliente GTK/Cairo
```

## Licencia

MIT — Edge Marketing Agency.