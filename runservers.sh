#!/bin/bash

export JAVA_HOME=/etc/alternatives/jre_openjdk
cd /opt/redis-stable/utils
echo -n | ./install_server.sh
cd /opt/aberowl-meta/aberowl-web
./start-server.sh &
cd /opt/aberowl-meta/aberowl-server
source "/root/.sdkman/bin/sdkman-init.sh"
groovy AberOWLServer.groovy 31337 &
cd /opt/aberowl-meta/aberowl-sync
groovy RemoteOntologyDiscover.groovy
groovy RemoteOntologyUpdate.groovy
