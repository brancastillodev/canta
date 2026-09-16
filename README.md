https://github.com/user-attachments/assets/8bb8ffd2-5463-4d41-9f77-7d1099618f32

# Canta 🎵

Programa para mostrar la letra de lo que esta sonando en tu linux.

Program to show the lyrics of what's playing on your linux.

Medio mágico: detecta la canción **instantáneamente** (MPRIS/playerctl) para Spotify, YouTube en el navegador, VLC, etc. Y si la fuente no expone metadata (Instagram, TikTok, streaming random), cae a **Shazam** (`songrec`) con un spinner mientras escucha el audio del sistema.

## Instalación

### 1. Dependencias

#### Ubuntu / Debian / Linux Mint / Pop!_OS

```
sudo apt install songrec playerctl
sudo npm install -g glyrics
```

#### Fedora / Nobara / Rocky Linux

```
sudo dnf install songrec playerctl
sudo npm install -g glyrics
```

#### Arch Linux / Manjaro / EndeavourOS

```
sudo pacman -S songrec playerctl
sudo npm install -g glyrics
```

> `playerctl` da la ruta rápida (instantánea). Sin él, Canta usa solo Shazam (~10-12s) con un spinner.

### 2. Clonar el repositorio

```
git clone https://github.com/brancastillodev/canta.git
cd canta
```

## Uso

```
./canta.sh               # detecta la canción y muestra la letra
./canta.sh --loop        # modo continuo: espera la siguiente canción
```

## Solución de problemas

### No se reconoce la canción

1. Probá con otra canción
2. Verificá que el audio del sistema esté siendo capturado correctamente
3. Si estás sin `playerctl` y la fuente es Spotify, YouTube en Chrome/FF, VLC, etc.: instalá `playerctl` para que la detección sea instantánea (ver arriba).

### Tarda 10-12 segundos

Es normal: es la ruta de Shazam (`songrec`), que necesita ~10s de audio para hacer el fingerprint. Si la app que usás soporta MPRIS (Spotify, Chrome, Firefox, VLC), con `playerctl` instalado la detección es instantánea.

### La letra no es la correcta

1. Proba con otra canción

## Licencia

MIT

## Créditos

- [SongRec](https://github.com/marin-m/SongRec) - Cliente de Shazam para Linux
- [playerctl](https://github.com/altdesktop/playerctl) - Pausa, salta o saca info de la canción activa
- [glyrics](https://github.com/candh/glyrics) - Buscador de letras de Genius.com
