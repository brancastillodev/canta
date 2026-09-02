# Canta 🎵

Script para reconocer canciones que suenen en tu linux y mostrar la letra en la terminal.

Script to recognize songs playing on your linux system and display the lyrics.


## Instalación

### Clonar el repositorio

```
git clone https://github.com/brancastillodev/canta.git
cd canta
```

### Instalar dependencias

### Ubuntu / Debian / Linux Mint / Pop!_OS

```
# Instalar songrec
sudo apt install songrec

# Instalar glyrics
sudo npm install -g glyrics
```

### Fedora / Nobara / Rocky Linux

```
# Instalar songrec
sudo dnf install songrec

# Instalar glyrics
sudo npm install -g glyrics
```

### Arch Linux / Manjaro / EndeavourOS

```
# Instalar songrec (disponible en los repos oficiales)
sudo pacman -S songrec

# Instalar glyrics
sudo npm install -g glyrics
```

## Uso

```
./canta.sh
```

## Dispositivo de audio

El script auto-detecta el monitor de audio activo.

## Solución de problemas

### "No se detectó ningún monitor de audio"

1. Verificá que PulseAudio o PipeWire esté corriendo:

```
pactl info
```

2. Verificá que haya monitores de audio disponibles:

```
pactl list sources short | grep monitor
```

### SongRec no reconoce canciones

1. Asegurate de tener conexión a internet
2. Probá con otra canción
3. Verificá que el audio del sistema esté siendo capturado correctamente

### glyrics no muestra letras

1. Verificá la conexión a internet
2. Probá con el comando directo:

```
glyrics "artista nombre de canción"
```

## Licencia

MIT

## Créditos

- [SongRec](https://github.com/marin-m/SongRec) - Cliente de Shazam para Linux
- [glyrics](https://github.com/candh/glyrics) - Buscador de letras de Genius.com
