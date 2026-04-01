import subprocess
import threading
import os
from datetime import datetime, timezone
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.rgb import Color
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)
from kitty.utils import color_as_int

# --- Configuration ---
ICON = "  "
RIGHT_MARGIN = 1
REFRESH_TIME = 15      # Seconds between clock updates
WEATHER_REFRESH = 1800 # 30 minutes
LOCATION = "Indianapolis"
CACHE_FILE = "/tmp/kitty_weather_cache.txt"

# Colors
icon_fg = as_rgb(color_as_int(Color(255, 250, 205)))
icon_bg = as_rgb(color_as_int(Color(47, 61, 68)))
clock_color = as_rgb(0x7FBBB3)
dnd_color = as_rgb(0x465258)
sep_color = as_rgb(0x999F93)
weather_color = as_rgb(0x717374)

# Global State
timer_id = None
cached_weather = "⏱️ Loading..."
weather_lock = threading.Lock()
is_fetching = False  # Prevent multiple simultaneous threads

def get_cache_age():
    try:
        return datetime.now().timestamp() - os.path.getmtime(CACHE_FILE)
    except OSError:
        return 999999

def fetch_weather_task():
    global cached_weather, is_fetching
    try:
        # 5s timeout; specifically ignore HTML responses if wttr.in is down
        cmd = f"curl -s --max-time 5 -H 'User-Agent: curl' 'wttr.in/{LOCATION}?format=%c%t'"
        output = subprocess.check_output(cmd, shell=True).decode("utf-8").strip()
        
        # VALIDATION: Ensure it's not empty, not HTML, and contains weather-like info
        if output and "<html" not in output.lower() and any(char in output for char in "+-°0123456789"):
            with open(CACHE_FILE, "w") as f:
                f.write(output)
            with weather_lock:
                cached_weather = output
        elif os.path.exists(CACHE_FILE) and os.path.getsize(CACHE_FILE) == 0:
            # If we fetched but it's bad and the file is empty, delete it to trigger retry
            os.remove(CACHE_FILE)
    except Exception:
        pass
    finally:
        is_fetching = False

def update_weather_asynchronously():
    global is_fetching
    if is_fetching:
        return
    is_fetching = True
    thread = threading.Thread(target=fetch_weather_task)
    thread.daemon = True
    thread.start()

def _redraw_tab_bar(timer_id):
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()

def _get_dnd_status():
    try:
        path = os.path.expanduser("~/.dotfiles/bin/dnd")
        result = subprocess.run(f"{path} -k", shell=True, capture_output=True, timeout=1)
        return result.stdout.decode("utf-8").strip() if result.stdout else ""
    except:
        return ""

def _draw_icon(screen: Screen, index: int) -> int:
    if index != 1: return 0
    fg, bg = screen.cursor.fg, screen.cursor.bg
    screen.cursor.fg, screen.cursor.bg = icon_fg, icon_bg
    screen.draw(ICON)
    screen.cursor.fg, screen.cursor.bg = fg, bg
    screen.cursor.x = len(ICON)
    return screen.cursor.x

def _draw_left_status(draw_data, screen, tab, before, max_title_length, index, is_last, extra_data) -> int:
    if draw_data.leading_spaces:
        screen.draw(" " * draw_data.leading_spaces)
    draw_title(draw_data, screen, tab, index)
    trailing_spaces = min(max_title_length - 1, draw_data.trailing_spaces)
    max_title_length -= trailing_spaces
    extra = screen.cursor.x - before - max_title_length
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw("…")
    if trailing_spaces:
        screen.draw(" " * trailing_spaces)
    screen.cursor.bold = screen.cursor.italic = False
    screen.cursor.fg = 0
    if not is_last:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.inactive_bg))
        screen.draw(draw_data.sep)
    screen.cursor.bg = 0
    return screen.cursor.x

def _draw_right_status(screen: Screen, is_last: bool) -> int:
    if not is_last:
        return screen.cursor.x

    global timer_id, cached_weather

    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)

    age = get_cache_age()

    # 1. READ CACHE (Only if valid)
    if "Loading..." in cached_weather or "Offline" in cached_weather:
        if os.path.exists(CACHE_FILE):
            if os.path.getsize(CACHE_FILE) > 0:
                try:
                    with open(CACHE_FILE, "r") as f:
                        content = f.read().strip()
                        if content and "Unknown" not in content and "<html" not in content.lower():
                            cached_weather = content
                except:
                    pass
            else:
                # Clean up empty files immediately
                try: os.remove(CACHE_FILE)
                except: pass

    # 2. TRIGGER UPDATE
    # If the file is missing (age 999999) or old, we fetch
    if age > WEATHER_REFRESH:
        update_weather_asynchronously()

    # 3. DISPLAY LOGIC
    with weather_lock:
        if not cached_weather or "Loading..." in cached_weather:
            # Only show Offline if the cache is actually missing/old
            display_weather = "󰖪 Offline" if age > WEATHER_REFRESH else cached_weather
        else:
            display_weather = cached_weather

    draw_attributed_string(Formatter.reset, screen)
    clock = datetime.now().strftime("%I:%M %p")
    dnd = _get_dnd_status()

    cells = []
    if dnd:
        cells.append((dnd_color, dnd))
        cells.append((sep_color, " ⋮ "))

    cells.append((weather_color, display_weather))
    cells.append((sep_color, " ⋮ "))
    cells.append((clock_color, clock))

    status_width = sum(len(str(cell[1])) for cell in cells)
    draw_pos = screen.columns - status_width - RIGHT_MARGIN

    if draw_pos > screen.cursor.x:
        screen.cursor.x = draw_pos
    else:
        return screen.cursor.x

    for color, status in cells:
        screen.cursor.fg = color
        screen.draw(status)
    
    screen.cursor.bg = 0
    return screen.cursor.x

def draw_tab(draw_data, screen, tab, before, max_title_length, index, is_last, extra_data) -> int:
    _draw_icon(screen, index)
    _draw_left_status(draw_data, screen, tab, before, max_title_length, index, is_last, extra_data)
    _draw_right_status(screen, is_last)
    return screen.cursor.x
