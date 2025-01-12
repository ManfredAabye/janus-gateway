#!/bin/bash

echo "Mettre à jour et installer les dépendances et télécharger et compiler le code source de Janus oui[non]?"
read -r install
if [ "$install" = "oui" ] || [ "$install" = "o" ]; then
    # Mettre à jour et installer les dépendances
    sudo apt update
    sudo apt install -y build-essential pkg-config zlib1g-dev libssl-dev libjansson-dev libnice-dev libsrtp2-dev libmicrohttpd-dev libwebsockets-dev cmake libsofia-sip-ua-dev libglib2.0-dev libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev libconfig-dev libtool automake

    echo "Télécharger et compiler le code source de Janus"
    # Télécharger et compiler le code source de Janus
    git clone https://github.com/meetecho/janus-gateway.git
    cd janus-gateway || exit
    sh autogen.sh
    ./configure --prefix=/opt/janus
    make
    sudo make install
fi

function renameconfigs () {
    echo "Renommer les fichiers de configuration"
    cd /opt/janus/etc/janus || exit

    # Renommer les fichiers de configuration d'exemple
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

# Démarrer Janus et/ou renommer les fichiers de configuration.
echo "1. Démarrer Janus, 2. Renommer les fichiers de configuration, 3. Renommer les fichiers de configuration et démarrer Janus: "
read -r myconfig
if [ "$myconfig" == "1" ]; then
    sudo /opt/janus/bin/janus
elif [ "$myconfig" == "2" ]; then
    renameconfigs
    echo "Veuillez maintenant configurer les fichiers de configuration dans le répertoire /opt/janus/etc/janus/."
elif [ "$myconfig" == "3" ]; then
    renameconfigs
    sudo /opt/janus/bin/janus
else
    echo "Sélection invalide. Veuillez entrer 1, 2 ou 3."
fi

echo "_________________________________________________________________"

echo "
Pour arrêter et redémarrer le serveur Janus, vous pouvez utiliser les commandes suivantes:

# Arrêter le serveur Janus
sudo systemctl stop janus

# Redémarrer le serveur Janus
sudo systemctl start janus

# Configurer le serveur Janus
Pour configurer de manière optimale le serveur Janus avec le projet os-webrtc-janus, 
vous devez ajuster les fichiers de configuration et vous assurer que les plugins requis et les paramètres sont correctement configurés.
Voici quelques étapes que vous pouvez suivre:

1. Ajuster les fichiers de configuration:
Modifier les fichiers de configuration dans /opt/janus/etc/janus/ 
pour effectuer les réglages souhaités. Par exemple:
nano /opt/janus/etc/janus/janus.jcfg

2. Exemple pour ajuster le fichier janus.jcfg:
nano /opt/janus/etc/janus/janus.jcfg

# Exemple de configuration avec SSL
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

3. Exemple pour ajuster le fichier janus.jcfg sans SSL:
nano /opt/janus/etc/janus/janus.jcfg

# Exemple de configuration sans SSL
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

4. Activer les plugins:
Assurez-vous que les plugins requis sont activés dans le fichier de configuration. Par exemple:
nano /opt/janus/etc/janus/janus.plugin.echotest.jcfg

# Exemple pour janus.plugin.echotest.jcfg
echotest: {
    enabled = true
    min_port = 40000
    max_port = 41000
}

5. Configurer HTTPS:
Si vous souhaitez utiliser HTTPS, 
vous devez configurer les certificats SSL et effectuer les réglages correspondants dans le fichier de configuration.

6. Lire la documentation:
Consultez la documentation des deux projets pour vous assurer que toutes les étapes sont correctement suivies. 
Vous pouvez trouver la documentation de Janus sur GitHub: github.com/meetecho/janus-gateway.

7. Copier et ajuster les fichiers de configuration:
Copiez les fichiers de configuration d'exemple et ajustez-les.
"
