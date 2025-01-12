#!/bin/bash

echo "Update und Installieren der Abhängigkeiten und Janus-Quellcode herunterladen und kompilieren ja[nein]?"
read -r install
if [ "$install" = "ja" ] || [ "$install" = "j" ]; then
    # Update und Installieren der Abhängigkeiten
    sudo apt update
    sudo apt install -y build-essential pkg-config zlib1g-dev libssl-dev libjansson-dev libnice-dev libsrtp2-dev libmicrohttpd-dev libwebsockets-dev cmake libsofia-sip-ua-dev libglib2.0-dev libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev libconfig-dev libtool automake

    echo "Janus-Quellcode herunterladen und kompilieren"
    # Janus-Quellcode herunterladen und kompilieren
    git clone https://github.com/meetecho/janus-gateway.git
    cd janus-gateway || exit
    sh autogen.sh
    ./configure --prefix=/opt/janus
    make
    sudo make install
fi

function renameconfigs () {
    echo "Konfigurationsdateien entkommentieren"
    cd /opt/janus/etc/janus || exit

    # Beispiel-Konfigurationsdateien entkommentieren
    cp janus.jcfg.sample janus.jcfg
    cp janus.plugin.echotest.jcfg.sample janus.plugin.echotest.jcfg
    cp janus.plugin.streaming.jcfg.sample janus.plugin.streaming.jcfg
    cp janus.plugin.sip.jcfg.sample janus.plugin.sip.jcfg
    cp janus.plugin.videoroom.jcfg.sample janus.plugin.videoroom.jcfg
    cp janus.plugin.videocall.jcfg.sample janus.plugin.videocall.jcfg
    cp janus.plugin.audiobridge.jcfg.sample janus.plugin.audiobridge.jcfg
    cp janus.plugin.recordplay.jcfg.sample janus.plugin.recordplay.jcfg
    cp janus.transport.http.jcfg.sample janus.transport.http.jcfg
    cp janus.transport.websockets.jcfg.sample janus.transport.websockets.jcfg
}

echo "_________________________________________________________________"

# Janus starten und/oder Konfigurationsdateien entkommentieren.
echo "1. Janus starten, 2. Konfigurationsdateien entkommentieren, 3. Konfigurationsdateien entkommentieren und Janus starten: "
read -r myconfig
if [ "$myconfig" == "1" ]; then
    sudo /opt/janus/bin/janus
elif [ "$myconfig" == "2" ]; then
    renameconfigs
    echo "Konfigurieren sie jetzt bitte die Konfigurationsdateien im Verzeichnis /opt/janus/etc/janus/."
elif [ "$myconfig" == "3" ]; then
    renameconfigs
    sudo /opt/janus/bin/janus
else
    echo "Ungültige Auswahl. Bitte 1, 2 oder 3 eingeben."
fi

echo "_________________________________________________________________"

echo "
Um den Janus-Server zu stoppen und neu zu starten, kannst du die folgenden Befehle verwenden:

# Janus-Server stoppen
sudo systemctl stop janus

# Janus-Server neu starten
sudo systemctl start janus

# Janus-Server konfigurieren
Um den Janus-Server optimal mit dem Projekt os-webrtc-janus zu konfigurieren, 
solltest du die Konfigurationsdateien anpassen und sicherstellen, 
dass die erforderlichen Plugins und Einstellungen korrekt eingerichtet sind.
Hier sind einige Schritte, die du befolgen kannst:

1. Konfigurationsdateien anpassen:
Bearbeite die Konfigurationsdateien in /opt/janus/etc/janus/, 
um die gewünschten Einstellungen vorzunehmen. Zum Beispiel:
nano /opt/janus/etc/janus/janus.jcfg

2. Beispiel zur Anpassung der janus.jcfg Datei:
nano /opt/janus/etc/janus/janus.jcfg

# Beispielkonfiguration mit SSL
general: {
    admin_secret = \"adminpwd\"
    server_name = \"Janus WebRTC Server\"
}

plugins_folder = \"/opt/janus/lib/janus/plugins\"
transports_folder = \"/opt/janus/lib/janus/transports\"

plugins: [
    \"janus.plugin.echotest\"
    \"janus.plugin.streaming\"
    \"janus.plugin.sip\"
    \"janus.plugin.videoroom\"
    \"janus.plugin.videocall\"
    \"janus.plugin.audiobridge\"
]

transports: [
    \"janus.transport.http\"
    \"janus.transport.websockets\"
]

http = true
secure_port = 8089
cert_pem = \"/path/to/your/cert.pem\"
cert_key = \"/path/to/your/key.pem\"

3. Beispiel zur Anpassung der janus.jcfg Datei ohne SSL:
nano /opt/janus/etc/janus/janus.jcfg

# Beispielkonfiguration ohne SSL
general: {
    admin_secret = \"adminpwd\"
    server_name = \"Janus WebRTC Server\"
}
nat: {
    stun_server = \"stun.l.google.com:19302\"
    # turn_server = \"turn.example.com\"
    # turn_user = \"myuser\"
    # turn_pwd = \"mypass\"
}
media: {
    rtp_port_range = \"10000-10200\"
    rtp_max_nacks = 5
    video: {
        codec = \"vp8\"
        rtp_profile = \"avpf\"
    }
    audio: {
        codec = \"opus\"
    }
}
plugins: {
    JanusEchoTest: {
        enabled = true
    }
}
http = true
http_port = 8088

4. Plugins aktivieren:
Stelle sicher, dass die benötigten Plugins in der Konfigurationsdatei aktiviert sind. Zum Beispiel:
nano /opt/janus/etc/janus/janus.plugin.echotest.jcfg

# Beispiel für janus.plugin.echotest.jcfg
echotest: {
    enabled = true
    min_port = 40000
    max_port = 41000
}

5. HTTPS konfigurieren:
Wenn du HTTPS verwenden möchtest, 
musst du die SSL-Zertifikate konfigurieren und die entsprechenden Einstellungen in der Konfigurationsdatei vornehmen.

6. Dokumentation lesen:
Überprüfe die Dokumentation beider Projekte, um sicherzustellen, dass alle Schritte korrekt befolgt werden. 
Die Dokumentation von Janus findest du auf GitHub: github.com/meetecho/janus-gateway.

7. Konfigurationsdateien kopieren und anpassen:
Kopiere die Beispiel-Konfigurationsdateien um und passe sie an.
"
