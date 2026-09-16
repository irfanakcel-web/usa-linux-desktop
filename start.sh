#!/bin/bash

set -e

export DISPLAY=:1
PORT="${PORT:-8080}"

# Start virtual display
Xvfb :1 -screen 0 1280x720x24 -ac &

sleep 2

# Start XFCE desktop
dbus-launch --exit-with-session startxfce4 &

sleep 5

# Start VNC server locally
x11vnc \
    -display :1 \
    -forever \
    -shared \
    -localhost \
    -rfbport 5900 \
    -nopw &

sleep 3

# Start Chromium browser
google-chrome \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --start-maximized \
    "https://www.google.com" &

sleep 3

# Start noVNC browser-based desktop
exec /opt/noVNC/utils/novnc_proxy \
    --vnc localhost:5900 \
    --listen 0.0.0.0:"$PORT"
