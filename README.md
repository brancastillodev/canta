# Canta 🎵

Script para reconocer canciones que suenan en tu sistema de audio y mostrar la letra automáticamente.

## Características

- Auto-detecta el dispositivo de audio activo
- Reconoce canciones usando Shazam (via SongRec)
- Muestra la letra de la canción (via glyrics)
- Funciona con PulseAudio y PipeWire

## Instalación

### Dependencias

- `songrec` - Cliente de Shazam para Linux
- `glyrics` - Buscador de letras de canciones
- `pactl` - Herramientas de audio (PulseAudio/PipeWire)

### Ubuntu / Debian / Linux Mint / Pop!_OS

```bash
# Instalar songrec
sudo apt update
sudo apt install songrec

# Instalar Node.js y npm (si no los tenés)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar glyrics
sudo npm install -g glyrics

# Instalar dependencias de audio (si no están instaladas)
sudo apt install pulseaudio pipewire-pulse
```

### Fedora / Nobara / Rocky Linux

```bash
# Instalar songrec
sudo dnf install songrec

# Instalar Node.js y npm (si no los tenés)
sudo dnf module install nodejs:22/common
# O alternativamente:
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
sudo dnf install -y nodejs

# Instalar glyrics
sudo npm install -g glyrics

# Instalar dependencias de audio (si no están instaladas)
sudo dnf install pulseaudio pipewire-pulseaudio
```

### Arch Linux / Manjaro / EndeavourOS

```bash
# Instalar songrec (disponible en los repos oficiales)
sudo pacman -S songrec

# Instalar Node.js y npm (si no los tenés)
sudo pacman -S nodejs npm

# Instalar glyrics
sudo npm install -g glyrics

# Instalar dependencias de audio (si no están instaladas)
sudo pacman -S pipewire-pulse
```

## Uso

```bash
# Ejecutar el script
canta

# O ejecutar directamente
~/.scripts/canta.sh
```

## Configuración

### Alias (opcional)

Para agregar un alias en tu `~/.bashrc` o `~/.zshrc`:

```bash
echo 'alias canta="~/.scripts/canta.sh"' >> ~/.bashrc
source ~/.bashrc
```

## Dispositivo de audio

El script auto-detecta el monitor de audio activo. Si necesitás especificar un dispositivo manualmente, editá el script y cambia la línea:

```bash
DEVICE=$(pactl list sources short 2>/dev/null | grep -i monitor | grep RUNNING | awk '{print $2}' | head -n1)
```

Por el nombre de tu dispositivo, por ejemplo:

```bash
DEVICE="alsa_output.usb-M-Audio_M-Track-00.analog-stereo.monitor"
```

## Solución de problemas

### "No se detectó ningún monitor de audio"

1. Verificá que PulseAudio o PipeWire esté corriendo:
   ```bash
   pactl info
   ```

2. Verificá que haya monitores de audio disponibles:
   ```bash
   pactl list sources short | grep monitor
   ```

### SongRec no reconoce canciones

1. Asegurate de tener conexión a internet
2. Probá con otra canción
3. Verificá que el audio del sistema esté siendo capturado correctamente

### glyrics no muestra letras

1. Verificá la conexión a internet
2. Probá con el comando directo:
   ```bash
   glyrics "artista nombre de canción"
   ```

## Licencia

MIT

## Créditos

- [SongRec](https://github.com/marin-m/SongRec) - Cliente de Shazam para Linux
- [glyrics](https://github.com/candh/glyrics) - Buscador de letras de Genius.com
