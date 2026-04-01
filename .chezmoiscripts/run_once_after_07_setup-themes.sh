#!/usr/bin/env bash
# Install GTK/QT themes system wide

GTK_THEME="Windows10Dark"
ICON_THEME="Windows10"
CURSOR_THEME="Windows-10"
CURSOR_SIZE=24

# Set XDG defaults (just in case)
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

THEME_DIR_USER="$XDG_DATA_HOME/themes"
ICON_DIR_USER="$XDG_DATA_HOME/icons"

THEME_DIR_SYS="/usr/share/themes"
ICON_DIR_SYS="/usr/share/icons"

echo "Configuring GTK, Cursor, and Flatpak themes..."

mkdir -p "$THEME_DIR_USER"
mkdir -p "$ICON_DIR_USER"
mkdir -p "$ICON_DIR_USER/default"
mkdir -p "$XDG_CONFIG_HOME/gtk-3.0"
mkdir -p "$XDG_CONFIG_HOME/gtk-4.0"
mkdir -p "$XDG_CONFIG_HOME/environment.d"

if [[ ! -d "$THEME_DIR_USER/$GTK_THEME" && ! -d "$THEME_DIR_SYS/$GTK_THEME" ]]; then
    echo "GTK theme '$GTK_THEME' not found."
    exit 1
fi

if [[ ! -d "$ICON_DIR_USER/$ICON_THEME" && ! -d "$ICON_DIR_SYS/$ICON_THEME" ]]; then
    echo "Icon theme '$ICON_THEME' not found."
    exit 1
fi

if [[ ! -d "$ICON_DIR_USER/$CURSOR_THEME" && ! -d "$ICON_DIR_SYS/$CURSOR_THEME" ]]; then
    echo "Cursor theme '$CURSOR_THEME' not found."
    exit 1
fi

cat > "$ICON_DIR_USER/default/index.theme" <<EOF
[Icon Theme]
Inherits=$CURSOR_THEME
EOF

cat > "$XDG_CONFIG_HOME/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=$GTK_THEME
gtk-icon-theme-name=$ICON_THEME
gtk-cursor-theme-name=$CURSOR_THEME
gtk-cursor-theme-size=$CURSOR_SIZE
gtk-application-prefer-dark-theme=1
EOF

cat > "$XDG_CONFIG_HOME/gtk-4.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=$GTK_THEME
gtk-icon-theme-name=$ICON_THEME
gtk-cursor-theme-name=$CURSOR_THEME
gtk-cursor-theme-size=$CURSOR_SIZE
gtk-application-prefer-dark-theme=1
EOF

cat > "$XDG_CONFIG_HOME/gtkrc-2.0" <<EOF
gtk-theme-name="$GTK_THEME"
gtk-icon-theme-name="$ICON_THEME"
gtk-cursor-theme-name="$CURSOR_THEME"
gtk-cursor-theme-size=$CURSOR_SIZE
gtk-application-prefer-dark-theme=1
EOF

cat > "$XDG_CONFIG_HOME/environment.d/theme.conf" <<EOF
XCURSOR_THEME=$CURSOR_THEME
XCURSOR_SIZE=$CURSOR_SIZE
GTK_THEME=$GTK_THEME
EOF

if command -v gsettings &> /dev/null; then
    if gsettings writable org.gnome.desktop.interface gtk-theme &>/dev/null; then
        echo "Updating GSettings..."
        gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
        gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
        gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME"
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    fi
fi

if command -v flatpak &> /dev/null; then
    echo "Applying Flatpak overrides..."

    flatpak override --user --filesystem=xdg-data/themes:ro
    flatpak override --user --filesystem=xdg-data/icons:ro

    flatpak override --user --env=GTK_THEME="$GTK_THEME"
    flatpak override --user --env=ICON_THEME="$ICON_THEME"
    flatpak override --user --env=XCURSOR_THEME="$CURSOR_THEME"
    flatpak override --user --env=XCURSOR_SIZE="$CURSOR_SIZE"
fi

if command -v hyprctl &> /dev/null; then
    hyprctl setcursor "$CURSOR_THEME" "$CURSOR_SIZE" 2>/dev/null || true
fi

echo "Done! Theme configuration complete."
