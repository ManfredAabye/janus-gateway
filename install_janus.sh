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

# Janus starten
sudo /opt/janus/bin/janus

echo "
Um den Janus-Server zu stoppen und neu zu starten, kannst du die folgenden Befehle verwenden:

# Janus-Server stoppen

sudo systemctl stop janus


# Janus-Server neu starten

sudo systemctl start janus


# Janus-Server konfigurieren

Um den Janus-Server optimal mit dem Projekt os-webrtc-janus zu konfigurieren, 
solltest du die Konfigurationsdateien anpassen und sicherstellen, dass die erforderlichen Plugins und Einstellungen korrekt eingerichtet sind.

Hier sind einige Schritte, die du befolgen kannst:

Konfigurationsdateien anpassen: Bearbeite die Konfigurationsdateien in /opt/janus/etc/janus/, um die gewünschten Einstellungen vorzunehmen. Zum Beispiel:

nano /opt/janus/etc/janus/janus.cfg


Plugins aktivieren: Stelle sicher, dass die benötigten Plugins in der Konfigurationsdatei aktiviert sind. Zum Beispiel:

nano /opt/janus/etc/janus/janus.plugin.echotest.jcfg


HTTPS konfigurieren: Wenn du HTTPS verwenden möchtest, musst du die SSL-Zertifikate konfigurieren und die entsprechenden Einstellungen in der Konfigurationsdatei vornehmen.

Dokumentation lesen: Überprüfe die Dokumentation beider Projekte, um sicherzustellen, dass alle Schritte korrekt befolgt werden. 
Die Dokumentation von Janus findest du auf GitHub: github.com/meetecho/janus-gateway."

