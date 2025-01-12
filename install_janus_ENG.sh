#!/bin/bash

echo "Update and install dependencies and download and compile Janus source code yes[no]?"
read -r install
if [ "$install" = "yes" ] || [ "$install" = "y" ]; then
    # Update and install dependencies
    sudo apt update
    sudo apt install -y build-essential pkg-config zlib1g-dev libssl-dev libjansson-dev libnice-dev libsrtp2-dev libmicrohttpd-dev libwebsockets-dev cmake libsofia-sip-ua-dev libglib2.0-dev libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev libconfig-dev libtool automake

    echo "Downloading and compiling Janus source code"
    # Download and compile Janus source code
    git clone https://github.com/meetecho/janus-gateway.git
    cd janus-gateway || exit
    sh autogen.sh
    ./configure --prefix=/opt/janus
    make
    sudo make install
fi

function renameconfigs () {
    echo "Renaming configuration files"
    cd /opt/janus/etc/janus || exit

    # Renaming sample configuration files
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

# Start Janus and/or rename configuration files.
echo "1. Start Janus, 2. Rename configuration files, 3. Rename configuration files and start Janus: "
read -r myconfig
if [ "$myconfig" == "1" ]; then
    sudo /opt/janus/bin/janus
elif [ "$myconfig" == "2" ]; then
    renameconfigs
    echo "Please configure the configuration files in the /opt/janus/etc/janus/ directory now."
elif [ "$myconfig" == "3" ]; then
    renameconfigs
    sudo /opt/janus/bin/janus
else
    echo "Invalid selection. Please enter 1, 2, or 3."
fi

echo "_________________________________________________________________"

echo "
To stop and restart the Janus server, you can use the following commands:

# Stop the Janus server
sudo systemctl stop janus

# Restart the Janus server
sudo systemctl start janus

# Configure the Janus server
To optimally configure the Janus server with the os-webrtc-janus project, 
you should adjust the configuration files and ensure that the required plugins and settings are correctly set up.
Here are some steps you can follow:

1. Adjust configuration files:
Edit the configuration files in /opt/janus/etc/janus/ 
to make the desired settings. For example:
nano /opt/janus/etc/janus/janus.jcfg

2. Example to adjust the janus.jcfg file:
nano /opt/janus/etc/janus/janus.jcfg

# Example configuration with SSL
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

3. Example to adjust the janus.jcfg file without SSL:
nano /opt/janus/etc/janus/janus.jcfg

# Example configuration without SSL
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

4. Activate plugins:
Make sure the required plugins are enabled in the configuration file. For example:
nano /opt/janus/etc/janus/janus.plugin.echotest.jcfg

# Example for janus.plugin.echotest.jcfg
echotest: {
    enabled = true
    min_port = 40000
    max_port = 41000
}

5. Configure HTTPS:
If you want to use HTTPS, 
you need to configure the SSL certificates and make the corresponding settings in the configuration file.

6. Read documentation:
Check the documentation of both projects to make sure that all steps are correctly followed. 
You can find the Janus documentation on GitHub: github.com/meetecho/janus-gateway.

7. Copy and adjust configuration files:
Copy the sample configuration files and adjust them.
"
