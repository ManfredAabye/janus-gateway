# Janus WebRTC Server direkt auf Ubuntu 24 Server installieren

## 1. Abhängigkeiten installieren

Öffne das Terminal und führe die folgenden Befehle aus, um die erforderlichen Abhängigkeiten zu installieren:

```bash
sudo apt update
sudo apt install build-essential pkg-config zlib1g-dev libssl-dev libjansson-dev libnice-dev libsrtp0-dev libmicrohttpd-dev libwebsockets-dev cmake
```

## 2. Janus-Quellcode herunterladen und kompilieren

Lade den Janus-Quellcode von GitHub herunter:

```bash
git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
```

Führe die folgenden Befehle aus, um Janus zu kompilieren:

```bash

./autogen.sh
./configure
make
sudo make install
```

## 3. Janus starten

Starte den Janus-Server mit dem folgenden Befehl:

```bash
sudo janus
```

## 4. Plugins installieren und konfigurieren

Lade die benötigten Plugins herunter und installiere sie:

```bash
git clone https://github.com/meetecho/janus-plugin-echo.git
cd janus-plugin-echo
./autogen.sh
./configure
make
sudo make install
```

Konfiguriere die Plugins nach Bedarf.

## 5. Janus überprüfen

Öffne einen Webbrowser und gehe zu `http://localhost:8088` (oder der entsprechenden IP-Adresse und Portnummer), um sicherzustellen, dass der Janus-Server läuft und die Plugins korrekt installiert sind.
