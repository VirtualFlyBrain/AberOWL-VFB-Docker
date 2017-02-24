FROM    centos:centos6

# Install requirements:
RUN yum update -y && \
yum install -y wget git tcl gcc gcc-c++ kernel-devel make freetype fontconfig unzip zip

# Install Java8
RUN yum install -y java-1.8.0-openjdk-headless
RUN export JAVA_HOME=/etc/alternatives/jre_openjdk

# Install groovy
RUN curl -s get.sdkman.io | bash && \
source "$HOME/.sdkman/bin/sdkman-init.sh" && \
/bin/bash -l -c 'sdk install groovy'

# Install phantomjs
RUN cd /opt && \
curl -O https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/phantomjs/phantomjs-1.9.2-linux-x86_64.tar.bz2 && \
tar xvf phantomjs-1.9.2-linux-x86_64.tar.bz2 && \
cp phantomjs-1.9.2-linux-x86_64.tar.bz2 /usr/local/bin

# Install Node.js and npm
RUN curl --silent --location https://rpm.nodesource.com/setup | bash -
RUN yum install -y nodejs

# Install redis
RUN cd /opt && \
wget http://download.redis.io/redis-stable.tar.gz && \
tar xvzf redis-stable.tar.gz && \
cd redis-stable && \
cd deps && \
make hiredis jemalloc linenoise lua geohash-int && \
cd .. && \
make && \
make install

#Start redis
RUN cd /opt/redis-stable/utils && \
echo -n | ./install_server.sh

# Install AberOWL
RUN cd /opt  && \
git clone https://github.com/bio-ontology-research-group/aberowl-meta
COPY install /opt/aberowl-meta/install
RUN cd /opt/aberowl-meta/ && \
./install
RUN cd /opt/aberowl-meta/aberowl-web  && \
npm install jsdom && \
npm install xmlhttprequest && \
npm install databank && \
npm install phantomjs && \
npm install phantom && \
npm install xmldom && \
npm install cache-manager
RUN cd /opt/aberowl-meta/aberowl-web/node_modules/databank/ && \
npm install databank-redis

RUN  yum clean all

# Create server start script
COPY runservers.sh /opt/runservers.sh
RUN chmod +x /opt/runservers.sh && \
cat /opt/runservers.sh

# Sync only the VFB ontology
COPY RemoteOntologyDiscover.groovy /opt/aberowl-meta/aberowl-sync/RemoteOntologyDiscover.groovy

EXPOSE 3000
EXPOSE 31337
# start AberOWL servers:
ENTRYPOINT ["/opt/runservers.sh"]
