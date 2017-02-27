#!/usr/bin/env bash

export JAVA_HOME=/etc/alternatives/jre_openjdk
export SDKMAN_DIR=/opt/sdkman
curl -s get.sdkman.io | bash -
source "/opt/sdkman/bin/sdkman-init.sh"
sdk install groovy
cd /opt/redis-stable/utils
nohup echo -n | sudo ./install_server.sh &
cd /opt/aberowl-meta/aberowl-web
nohup ./start-server.sh &
cd /opt/aberowl-meta/aberowl-sync/
groovy ReloadAll.groovy
groovy UpdateAll.groovy
cd /opt/aberowl-meta/aberowl-server
groovy AberOWLServer.groovy 31337
