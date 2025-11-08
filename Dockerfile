# Credits: https://leimao.github.io/blog/Docker-Container-GUI-Display/
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBUG_PORT=9222
ENV VNC_PORT=5900
ENV VNC_PASSWORD=hyperaccs
ENV DISPLAY=:99

RUN apt-get update

RUN apt-get install -y \
	wget \
	libcanberra-gtk-module \
	libcanberra-gtk3-module \
	xvfb \
	x11vnc \
	fluxbox

RUN apt-get clean

RUN cd /tmp && \
	ARCH=$(dpkg --print-architecture) && \
	if [ "$ARCH" = "amd64" ]; then \
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
		apt-get install -y ./google-chrome-stable_current_amd64.deb; \
	else \
		apt-get install -y chromium-browser && \
		ln -s /usr/bin/chromium-browser /usr/bin/google-chrome; \
	fi

COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/bin/bash", "-c", "./entrypoint.sh"]
EXPOSE $DEBUG_PORT $VNC_PORT
