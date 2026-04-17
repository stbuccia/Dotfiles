#!/bin/bash
# Hook chiamato da Noctalia quando cambia la modalità chiara/scura.
# Argomento $1: "dark" oppure "light"

MODE="$1"

# Leggi il tema GTK corrente e ricava la base (es. "Yaru-red" da "Yaru-red-dark")
CURRENT=$(gsettings get org.gnome.desktop.interface gtk-theme | tr -d "'")
BASE="${CURRENT%-dark}"

if [ "$MODE" = "dark" ]; then
    gsettings set org.gnome.desktop.interface gtk-theme "${BASE}-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
else
    gsettings set org.gnome.desktop.interface gtk-theme "${BASE}"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
fi
