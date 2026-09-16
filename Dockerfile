FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    dbus-x11 \
    xvfb \
    x11vnc \
    chromium \
    git \
    python3 \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/novnc/noVNC.git /opt/noVNC

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
