#!/bin/bash

export JAVA_HOME=/etc/alternatives/jre_openjdk
source "/root/.sdkman/bin/sdkman-init.sh"
cd /opt/redis-stable/utils
echo -n | ./install_server.sh
cd /opt/aberowl-meta/aberowl-web
./start-server.sh &
cd /opt/aberowl-meta/aberowl-sync
groovy RemoteOntologyDiscover.groovy
groovy RemoteOntologyUpdate.groovy
cd /opt/aberowl-meta/aberowl-server
groovy AberOWLServer.groovy 31337
