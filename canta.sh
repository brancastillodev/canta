#!/bin/bash
# canta — Detecta la canción y muestra la letra en tu terminal.
#
# Fast-path: MPRIS/via playerctl (~instant, para Spotify/Chrome/VLC, etc.)
# Slow-path: Shazam via songrec (~10-12s, para Instagram/TikTok/streaming genérico)
#
# Uso:
#   ./canta              → detecta una canción y muestra la letra
#   ./canta --loop       → modo continuo (escucha y muestra letra para cada cambio)
#
# Salida:
#   0 →成功
#   1 → error
#
# Requisitos:
#   pactl (PulseAudio/PipeWire), songrec, glyrics, e instalar playerctl para la ruta rápida.
#   Arch: sudo pacman -S playerctl songrec glyrics-npm (glyrics: npm i -g glyrics)
#
# Licencia: MIT

set -euo pipefail

# ── Config ──────────────────────────────────────────────────────────────
TIMEOUT="${CANTA_TIMEOUT:-12}"
LOOP=0
[ "${1:-}" = "--loop" ] && LOOP=1

# ── Colores ─────────────────────────────────────────────────────────────
C_RESET='\033[0m'
C_BOLD='\033[1m'
C_CYAN='\033[36m'
C_YELLOW='\033[33m'
C_DIM='\033[2m'

# ── Helpers ─────────────────────────────────────────────────────────────
err()  { echo -e "❌ $*" >&2; }
info() { echo -e "${C_DIM}$*${C_RESET}"; }
ok()   { echo -e "${C_CYAN}🎵 ${C_BOLD}$*${C_RESET}"; }

spinner_frame() {
    local i=$1
    case $(( i % 4 )) in
        0) printf '⠋' ;;
        1) printf '⠙' ;;
        2) printf '⠸' ;;
        3) printf '⠴' ;;
    esac
}

detect_device() {
    DEVICE=$(pactl list sources short 2>/dev/null \
        | grep -i monitor | grep RUNNING | awk '{print $2}' | head -n1)

    if [ -z "$DEVICE" ]; then
        DEVICE=$(pactl list sources short 2>/dev/null \
            | grep -i monitor | awk '{print $2}' | head -n1)
    fi

    if [ -z "$DEVICE" ]; then
        err "No se detectó ningún monitor de audio activo."
        err "Asegurate de tener PulseAudio/PipeWire con el módulo de monitoreo."
        return 1
    fi
    return 0
}

# ── Fast-path: playerctl (MPRIS) ────────────────────────────────────────
try_playerctl() {
    command -v playerctl >/dev/null 2>&1 || return 1

    local info
    info=$(playerctl metadata --format '{{artist}}\t{{title}}' 2>/dev/null) || return 1

    local artista titulo
    artista=$(printf '%s' "$info" | cut -f1)
    titulo=$(printf '%s'  "$info" | cut -f2)

    # Ignorar vacíos
    [ -z "$artista" ] || [ -z "$titulo" ] && return 1
    # playerctl puede devolver placeholders como "Unknown artist"
    printf '%s' "$artista" | grep -qiE '^unknown$' && return 1

    printf '%s\t%s' "$artista" "$titulo"
    return 0
}

# ── Slow-path: songrec (Shazam) ─────────────────────────────────────────
recognize_songrec() {
    local device="$1" timeout="$2"
    local tmp
    tmp=$(mktemp)

    ( timeout "$timeout" songrec recognize -d "$device" > "$tmp" 2>/dev/null ) &
    local pid=$!
    local i=0

    # Spinner mientras corre
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r  %s Escuchando el audio del sistema..." "$(spinner_frame $i)" >&2
        i=$((i + 1))
        sleep 0.15
    done
    wait "$pid" 2>/dev/null
    printf "\r%s\r" "$(printf ' %.0s' {1..50})" >&2   # limpiar la línea

    local raw
    raw=$(cat "$tmp")
    rm -f "$tmp"

    # Verificar que no sea un "no reconocido"
    printf '%s' "$raw" | grep -qiE 'no se reconoció|not recognized' && return 1
    [ -z "$raw" ] && return 1

    # Parsear: songrec imprime "Artist - Title"
    local artista titulo
    artista=$(printf '%s' "$raw" | cut -d '-' -f 1 | sed 's/^ *//;s/ *$//')
    titulo=$(printf '%s'  "$raw" | cut -d '-' -f 2- | sed 's/^ *//;s/ *$//')

    [ -z "$titulo" ] && titulo="$artista"
    printf '%s\t%s' "$artista" "$titulo"
}

# ── Lyrics ──────────────────────────────────────────────────────────────
show_lyrics() {
    local artista="$1" titulo="$2"
    ok "$artista — $titulo"
    echo ""
    if ! command -v glyrics >/dev/null 2>&1; then
        info "⚠  glyrics no está instalado (npm i -g glyrics)"
        return
    fi
    glyrics --first "$artista $titulo" 2>/dev/null || info "⚠  No se encontró la letra."
}

# ── Main ────────────────────────────────────────────────────────────────
main() {
    detect_device || exit 1

    local artista titulo

    while true; do
        # 1) Fast path — playerctl (instantáneo)
        local pctl
        if pctl=$(try_playerctl); then
            artista=$(printf '%s' "$pctl" | cut -f1)
            titulo=$(printf '%s'  "$pctl" | cut -f2)
            show_lyrics "$artista" "$titulo"
        else
            # 2) Slow path — Shazam (songrec ~10s)
            info "🎧 Usando reconocimiento por audio (Shazam)..."
            if pctl=$(recognize_songrec "$DEVICE" "$TIMEOUT"); then
                artista=$(printf '%s' "$pctl" | cut -f1)
                titulo=$(printf '%s'  "$pctl" | cut -f2)
                show_lyrics "$artista" "$titulo"
            else
                err "No se pudo reconocer la canción."
            fi
        fi

        # Si no es modo loop, salir
        [ "$LOOP" -eq 0 ] && break
        echo ""
        info "─ Esperando siguiente canción... (Ctrl+C para salir)"
        # Resetear device por si cambió
        detect_device || exit 1
        # Pausa corta para no sobrecargar
        sleep 1
    done
}

main "$@"
