#!/bin/bash

# Update und Installieren der Abhängigkeiten
sudo apt update
sudo apt install -y build-essential pkg-config zlib1g-dev libssl-dev libjansson-dev libnice-dev libsrtp2-dev libmicrohttpd-dev libwebsockets-dev cmake libsofia-sip-ua-dev libglib2.0-dev libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev libconfig-dev libtool automake

# Janus-Quellcode herunterladen und kompilieren
git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway || exit
sh autogen.sh
./configure --prefix=/opt/janus
make
sudo make install

# Plugins installieren und konfigurieren
cd ..
git clone https://github.com/meetecho/janus-plugin-echo.git
cd janus-plugin-echo || exit
sh autogen.sh
./configure --prefix=/opt/janus
make
sudo make install

# Janus starten
sudo /opt/janus/bin/janus
