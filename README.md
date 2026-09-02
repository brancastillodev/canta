# Canta 🎵

Programa para mostrar la letra de lo que esta sonando en tu linux.

Program to show the lyrics of what's playing on your linux.


### Demo

https://github.com/brancastillodev/canta/releases/download/shell/canta-demo.mp4

## Instalación

### Clonar el repositorio

```
git clone https://github.com/brancastillodev/canta.git
cd canta
```

### Instalar dependencias

### Ubuntu / Debian / Linux Mint / Pop!_OS

```
sudo apt install songrec
sudo npm install -g glyrics
```

### Fedora / Nobara / Rocky Linux

```
sudo dnf install songrec
sudo npm install -g glyrics
```

### Arch Linux / Manjaro / EndeavourOS

```
sudo pacman -S songrec
sudo npm install -g glyrics
```

## Uso

```
./canta.sh
```

## Solución de problemas

### No se reconoce la canción

1. Probá con otra canción
2. Verificá que el audio del sistema esté siendo capturado correctamente

### La letra no es la correcta

1. Proba con otra canción

## Licencia

MIT

## Créditos

- [SongRec](https://github.com/marin-m/SongRec) - Cliente de Shazam para Linux
- [glyrics](https://github.com/candh/glyrics) - Buscador de letras de Genius.com
