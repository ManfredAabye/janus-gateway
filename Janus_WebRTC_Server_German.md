# Bash-Skript zur Installation von Janus WebRTC Server auf Ubuntu Server 24.04

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

Speichere das Skript in eine Datei, z.B. `install_janus.sh`.

Führe das Skript aus:

```bash
bash install_janus.sh
```

Das `janus_echotest.c` Plugin ist tatsächlich Teil der Janus-Plattform und sollte mit der normalen Installation von Janus bereits vorhanden sein.
Es scheint, dass es eine Verwechslung zwischen dem normalen `janus_echotest` Plugin und dem `janus-plugin-echo` gibt.
Das `janus_echotest` Plugin sollte bereits in deiner Installation enthalten sein und benötigt keine zusätzliche Installation.

## Überprüfung der Installation

1. **Überprüfe die vorhandenen Plugins**:
   Du kannst die vorhandenen Plugins in deinem Janus-Installationsverzeichnis überprüfen, um sicherzustellen, dass `janus_echotest` bereits installiert ist:

   ```bash
   ls /opt/janus/lib/janus/plugins
   ```

2. **Konfigurationsdateien überprüfen**:
   Überprüfe die Konfigurationsdateien, um sicherzustellen, dass das `janus_echotest` Plugin geladen wird:

   ```bash
   cat /opt/janus/etc/janus/janus.plugin.echotest.jcfg
   ```

3. **Janus-Server neu starten**:
   Starte den Janus-Server neu, um sicherzustellen, dass alle Plugins korrekt geladen werden:

   ```bash
   sudo /opt/janus/bin/janus
   ```

Um den Janus-Server zu stoppen und neu zu starten, kannst du die folgenden Befehle verwenden:

## Janus-Server stoppen

```bash
sudo systemctl stop janus
```

## Janus-Server neu starten

```bash
sudo systemctl start janus
```

## Janus-Server konfigurieren

Um den Janus-Server optimal mit dem Projekt `os-webrtc-janus` zu konfigurieren, solltest du die Konfigurationsdateien anpassen und sicherstellen, dass die erforderlichen Plugins und Einstellungen korrekt eingerichtet sind. Hier sind einige Schritte, die du befolgen kannst:

1. **Konfigurationsdateien anpassen**: Bearbeite die Konfigurationsdateien in `/opt/janus/etc/janus/`, um die gewünschten Einstellungen vorzunehmen. Zum Beispiel:

   ```bash
   nano /opt/janus/etc/janus/janus.cfg
   ```

2. **Plugins aktivieren**: Stelle sicher, dass die benötigten Plugins in der Konfigurationsdatei aktiviert sind. Zum Beispiel:

   ```bash
   nano /opt/janus/etc/janus/janus.plugin.echotest.jcfg
   ```

3. **HTTPS konfigurieren**: Wenn du HTTPS verwenden möchtest, musst du die SSL-Zertifikate konfigurieren und die entsprechenden Einstellungen in der Konfigurationsdatei vornehmen.

4. **Dokumentation lesen**: Überprüfe die Dokumentation beider Projekte, um sicherzustellen, dass alle Schritte korrekt befolgt werden.

Die Dokumentation von Janus findest du auf GitHub: [Janus WebRTC Server](https://github.com/meetecho/janus-gateway).

Die Warnungen, die du während der Installation von Janus siehst, betreffen ungenutzte Variablen im `janus_streaming.c` Plugin.

Diese Warnungen deuten darauf hin, dass es im Quellcode Variablen gibt, die deklariert, aber nicht verwendet werden.

Diese Warnungen beeinträchtigen nicht die Funktionalität des Plugins oder des Servers, können aber zu unnötigem Code führen.

Hier sind einige Schritte, die du unternehmen kannst, um diese Warnungen zu beheben:

1. **Variablen auskommentieren oder entfernen**:
   Du kannst die ungenutzten Variablen in der `janus_streaming.c` Datei entweder auskommentieren oder entfernen.

2. **Code anpassen**:
   Füge den relevanten Codeabschnitten `#if 0` und `#endif` hinzu, um die ungenutzten Variablen auszuklammern, falls du sie später noch brauchen solltest.

### Beispiel für das Auskommentieren von ungenutzten Variablen

```c
// Unused variables commented out
#if 0
char *dmcast = NULL, *dmiface = NULL;
gboolean textdata = TRUE, buffermsg = FALSE;
uint16_t dport = 0;
janus_network_address data_iface;
#endif
```

### Beispiel für das Entfernen von ungenutzten Variablen

```c
// Remove unused variables directly
// char *dmcast = NULL, *dmiface = NULL;
// gboolean textdata = TRUE, buffermsg = FALSE;
// uint16_t dport = 0;
// janus_network_address data_iface;
```

### Schritte zur Umsetzung

1. Öffne die `janus_streaming.c` Datei:

   ```bash
   nano /path/to/janus/janus-gateway/plugins/janus_streaming.c
   ```

2. Suche die Zeilen mit den ungenutzten Variablen (z.B. `dmcast`, `dmiface`, `buffermsg`, `textdata`, `dport`, `data_iface`) und kommentiere sie aus oder entferne sie.

3. Speichere die Datei und kompiliere den Code erneut:

   ```bash
   cd /path/to/janus/janus-gateway
   make clean
   ./configure --prefix=/opt/janus
   make
   sudo make install
   ```

Diese Änderungen sollten die Warnungen bezüglich ungenutzter Variablen beseitigen.

Die Anpassungen sind jedoch rein kosmetischer Natur und haben keine Auswirkungen auf die Funktionsweise von Janus.

Es scheint, dass einige Plugins und Transportmodule des Janus WebRTC Servers nicht korrekt konfiguriert sind oder die entsprechenden Konfigurationsdateien fehlen.

Hier sind einige Schritte, um diese Probleme zu beheben:

## 1. Konfigurationsdateien erstellen

Stelle sicher, dass die Konfigurationsdateien für die Plugins und Transportmodule vorhanden sind. Hier sind Beispielkonfigurationsdateien für die wichtigsten Plugins und Transportmodule:

## Beispiel für `janus.plugin.echotest.jcfg`

```bash
nano /opt/janus/etc/janus/janus.plugin.echotest.jcfg

echotest: {
    enabled = true
    min_port = 40000
    max_port = 41000
}
```

## Beispiel für `janus.plugin.streaming.jcfg`

```bash
nano /opt/janus/etc/janus/janus.plugin.streaming.jcfg

streaming: {
    enabled = true
}
```

## Beispiel für `janus.transport.http.jcfg`

```bash
nano /opt/janus/etc/janus/janus.transport.http.jcfg

http: {
    enabled = true
    port = 8088
}
```

## 2. Verzeichnisse und Pfade überprüfen

Stelle sicher, dass die Konfigurationsdateien im richtigen Verzeichnis gespeichert sind und die Pfade korrekt sind.

## 3. Janus-Server mit dem neuen Befehl starten

Um den Janus-Server als Dienst zu starten und zu stoppen, kannst du `systemctl` verwenden. Stelle sicher, dass du eine Service-Datei für Janus erstellt hast:

## Beispiel für eine Systemd-Service-Datei `janus.service`

```bash
sudo nano /etc/systemd/system/janus.service

[Unit]
Description=Janus WebRTC Server
After=network.target

[Service]
ExecStart=/opt/janus/bin/janus
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target
```

Aktualisiere die Systemd-Dienste und starte Janus:

```bash
sudo systemctl daemon-reload
sudo systemctl enable janus
sudo systemctl start janus
```

### 4. Konfigurationsdateien überprüfen und anpassen

Stelle sicher, dass alle Plugins und Transportmodule in der Hauptkonfigurationsdatei `janus.jcfg` aktiviert sind.

```bash
nano /opt/janus/etc/janus/janus.jcfg

general: {
    admin_secret = "adminpwd"
    server_name = "Janus WebRTC Server"
}

plugins_folder = "/opt/janus/lib/janus/plugins"
transports_folder = "/opt/janus/lib/janus/transports"

plugins: [
    "janus.plugin.echotest"
    "janus.plugin.streaming"
    "janus.plugin.sip"
    "janus.plugin.videoroom"
    "janus.plugin.videocall"
    "janus.plugin.audiobridge"
]

transports: [
    "janus.transport.http"
    "janus.transport.websockets"
]
```

## Fazit

Mit diesen Schritten sollten die Fehler behoben werden und der Janus-Server korrekt starten und laufen.

Stelle sicher, dass alle Konfigurationsdateien vorhanden und korrekt sind.
