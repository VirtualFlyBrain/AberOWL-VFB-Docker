#!/usr/bin/env bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
cd /opt/redis-stable/utils
echo -n | ./install_server.sh &
cd /opt/aberowl-meta/jenkins/workspace
groovy CheckUpdate.groovy VFB
groovy Classify.groovy VFB
groovy Index.groovy VFB
groovy Restart.groovy VFB
cd /opt/aberowl-meta/aberowl-server
groovy AberOWLServer.groovy 31337
