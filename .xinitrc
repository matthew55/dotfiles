# Desktop background and transparency.
#[ -f ~/.fehbg ] && sh ~/.fehbg &
#[ ! -f ~/.fehbg ] && feh --bg-scale //Pictures/desktop-backgrounds/city-night.png
picom --config ~/.config/picom/picom.conf &

# Restore the last colorscheme that was in use.
wal -R &

# Start URxvt dameon for ram useage improvements.
# urxvtd -q -o -f &

 Get numpad working.
#numlockx &

# Get clipboard working
xclip &

# Load Xresources and redirect xrdb to PyWal's Xresource's file.
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources && xrdb -merge ~/.cache/wal/colors.Xresources

# Start our display manager
#dwmblocks &
exec dwm
