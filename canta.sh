#!/bin/bash

# Auto-detectar monitor de audio activo
DEVICE=$(pactl list sources short 2>/dev/null | grep -i monitor | grep RUNNING | awk '{print $2}' | head -n1)

if [ -z "$DEVICE" ]; then
    DEVICE=$(pactl list sources short 2>/dev/null | grep -i monitor | awk '{print $2}' | head -n1)
fi

if [ -z "$DEVICE" ]; then
    echo "❌ No se detectó ningún monitor de audio"
    exit 1
fi

# Detectar canción
RAW_OUTPUT=$(timeout 12 songrec recognize -d "$DEVICE" 2>/dev/null)

# Verificar si se detectó algo válido
if [ ! -z "$RAW_OUTPUT" ] && [[ "$RAW_OUTPUT" != *"No se reconoció"* ]]; then
    # Extraer artista y canción
    artista=$(echo "$RAW_OUTPUT" | cut -d '-' -f 1 | sed 's/^ *//;s/ *$//')
    cancion=$(echo "$RAW_OUTPUT" | cut -d '-' -f 2- | sed 's/^ *//;s/ *$//')
    
    # Limpiar: eliminar paréntesis y convertir a minúsculas
    cancion="${cancion% (*}"
    cancion="${cancion,,}"
    artista="${artista,,}"
    
    echo "🎵 $artista | $cancion"
    echo ""
    glyrics --first "$artista $cancion"
fi
