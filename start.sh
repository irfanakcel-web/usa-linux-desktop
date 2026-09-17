#!/bin/bash

set -e

export DISPLAY=:1
export XDG_CONFIG_DIRS=/etc/xdg/xdg-xfce:/etc/xdg
export XDG_CURRENT_DESKTOP=XFCE
export XDG_SESSION_DESKTOP=xfce

PORT="${PORT:-8080}"

# Start virtual display
Xvfb :1 -screen 0 1280x720x24 -ac +extension GLX +render -noreset &

sleep 2

# Start lightweight XFCE
dbus-launch --exit-with-session startxfce4 &

sleep 5

# Start VNC with compression optimized for browser/noVNC
x11vnc \
    -display :1 \
    -forever \
    -shared \
    -localhost \
    -rfbport 5900 \
    -nopw \
    -noxdamage \
    -repeat \
    -wait 5 \
    -defer 5 \
    -ncache 10 \
    -ncache_cr &

sleep 3

# Start Google Chrome
google-chrome \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --disable-software-rasterizer \
    --disable-background-networking \
    --disable-background-timer-throttling \
    --disable-renderer-backgrounding \
    --disable-features=Translate,MediaRouter,OptimizationHints \
    --disable-sync \
    --no-first-run \
    --no-default-browser-check \
    --start-maximized \
    "https://www.google.com" &

sleep 3

# Start noVNC
exec /opt/noVNC/utils/novnc_proxy \
    --vnc localhost:5900 \
    --listen 0.0.0.0:"$PORT"
