#!/bin/bash
Xvfb $DISPLAY -ac -listen tcp -screen 0 1920x1080x16 &
while ! pgrep "Xvfb" > /dev/null; do
    sleep .1
done
/usr/bin/fluxbox -display $DISPLAY -screen 0 &
while ! pgrep "fluxbox" > /dev/null; do
    sleep .1
done
x11vnc -display $DISPLAY -rfbport $VNC_PORT -forever -passwd $VNC_PASSWORD &
while ! pgrep "x11vnc" > /dev/null; do
    sleep .1
done

# Detect which browser to use
if command -v google-chrome &> /dev/null; then
    CHROME_CMD="google-chrome"
elif command -v chromium-browser &> /dev/null; then
    CHROME_CMD="chromium-browser"
else
    echo "Error: No browser found (neither google-chrome nor chromium-browser)"
    exit 1
fi

echo "Starting browser: $CHROME_CMD"

$CHROME_CMD --no-sandbox \
	--disable-dev-shm-usage \
	--disable-gpu \
	--remote-debugging-port=$DEBUG_PORT \
	--remote-debugging-address=0.0.0.0 \
	--no-default-browser-check
