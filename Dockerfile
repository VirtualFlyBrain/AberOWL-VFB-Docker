FROM    centos:centos6

# Install requirements:
RUN yum update -y && \
yum install -y wget git tcl gcc gcc-c++ kernel-devel make freetype fontconfig unzip zip

# Install Java8
RUN yum install -y java-1.8.0-openjdk-headless
RUN export JAVA_HOME=/etc/alternatives/jre_openjdk

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

EXPOSE 3000
EXPOSE 31337

# Copy base Ontology
COPY VFB.ont /opt/aberowl-meta/aberowl-server/onts/VFB_1.ont
COPY VFB.ont /opt/aberowl-meta/aberowl-server/onts/VFB_2.ont
COPY VFB.ont /opt/aberowl-meta/aberowl-server/onts/VFB_3.ont

# Create server start script
COPY runservers.sh /opt/runservers.sh
RUN chmod +x /opt/runservers.sh && \
cat /opt/runservers.sh

# Add only the VFB ontology
COPY dump.rdb /var/lib/redis/6379/dump.rdb

# Create SDK dir accessible
RUN chmod -R 777 /opt

RUN useradd -l --shell /usr/sbin/nologin --uid 1000000000 --gid 0 flybrain

WORKDIR /opt
ENV HOME=/opt
USER 1000000000
# start AberOWL servers:
ENTRYPOINT ["/opt/runservers.sh"]
