#!/usr/bin/env bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
cd /opt/redis-stable/utils
echo -n | ./install_server.sh &
sleep 30s
redis-cli SET "ontologies:VFB" "{\"id\":\"VFB\",\"name\":\"VFB\",\"description\":\"VFB individuals\",\"homepage\":\"http://virtualflybrain.org\",\"source\":\"https://raw.githubusercontent.com/VirtualFlyBrain/VFB_owl/Current/src/owl/vfb.owl.gz\",\"status\":\"tested\",\"purl\":null,\"ncbi_id\":null,\"submissions\":{},\"owners\":[\"Robbie\"],\"species\":[\"Drosophila\"],\"topics\":null,\"contact\":[\"support@virtualflybrain.org\"],\"lastSubDate\":1462543726}"
cd /opt/aberowl-meta/jenkins/workspace
groovy CheckUpdate.groovy VFB
groovy Classify.groovy VFB
groovy Index.groovy VFB
redis-cli SET "ontologies:VFB" "{\"id\":\"VFB\",\"name\":\"VFB\",\"description\":\"VFB individuals\",\"homepage\":\"http://virtualflybrain.org\",\"source\":\"https://raw.githubusercontent.com/VirtualFlyBrain/VFB_owl/Current/src/owl/vfb.owl.gz\",\"status\":\"tested\",\"purl\":null,\"ncbi_id\":null,\"submissions\":{\"1489440292\":\"VFB_1.ont\"},\"owners\":[\"Robbie\"],\"species\":[\"Drosophila\"],\"topics\":null,\"contact\":[\"support@virtualflybrain.org\"],\"lastSubDate\":1489440292}"
redis-cli GET "ontologies:VFB"
cd /opt/aberowl-meta/aberowl-server
groovy AberOWLServer.groovy 31337
