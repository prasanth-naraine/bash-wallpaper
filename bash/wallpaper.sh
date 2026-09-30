#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/.wallpapers"
INTERVAL=900 #15 mins once
LAST_WALLPAPER=""

while true; do
    mapfile -t WALLPAPERS < <(
        find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        \( -iname "*.jpg" \
           -o -iname "*.jpeg" \
           -o -iname "*.png" \
           -o -iname "*.webp" \) \
        | shuf
    )

    if [ ${#WALLPAPERS[@]} -eq 0 ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi

    for wallpaper in "${WALLPAPERS[@]}"; do

        # Avoid showing the same wallpaper twice in a row
        if [ "$wallpaper" = "$LAST_WALLPAPER" ] && [ ${#WALLPAPERS[@]} -gt 1 ]; then
            continue
        fi

        echo "Setting wallpaper: $wallpaper"

        gsettings set org.gnome.desktop.background picture-uri "file://$wallpaper"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaper"

        LAST_WALLPAPER="$wallpaper"

        sleep "$INTERVAL"
    done
done

