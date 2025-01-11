# Janus WebRTC Server direkt auf Ubuntu 24 Server installieren

# Ein Beispielskript, das alle notwendigen Schritte umfasst

## Bash-Skript zur Installation von Janus WebRTC Server auf Ubuntu

```bash

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

```

## Erläuterungen zum Skript

1. **Update und Installieren der Abhängigkeiten**:
   - Das Skript aktualisiert die Paketlisten und installiert alle notwendigen Abhängigkeiten für die Janus-Installation.

2. **Janus-Quellcode herunterladen und kompilieren**:
   - Es wird der Janus-Quellcode von GitHub heruntergeladen und kompiliert. Dabei wird `--prefix=/opt/janus` verwendet, um Janus im `/opt/janus` Verzeichnis zu installieren.

3. **Plugins installieren und konfigurieren**:
   - Es wird das Echo-Plugin heruntergeladen, kompiliert und installiert.

4. **Janus starten**:
   - Der Janus-Server wird gestartet.

## Ausführen des Skripts

1. Speichere das Skript in eine Datei, z.B. `install_janus.sh`.
2. Mache die Datei ausführbar:

   ```bash
   chmod +x install_janus.sh
   ```

3. Führe das Skript aus:

   ```bash
   bash install_janus.sh
   ```

