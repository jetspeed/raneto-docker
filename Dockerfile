# docker run -v `pwd`/content/:/data/content/ -v `pwd`/config/config.default.js:/opt/raneto/example/config.default.js -p 3000:3000 -d appsecco/raneto
#
# Reference (https://github.com/sparkfabrik/docker-node-raneto)
# Using official node:slim from the dockerhub (https://hub.docker.com/_/node/)
FROM node:slim
MAINTAINER Madhu Akula <madhu@appsecco.com>

# Change the raneto version based on version you want to use
ENV RANETO_INSTALL_DIR /opt/Raneto

# Get Raneto from sources
RUN apt-get update  && apt-get install git python g++ make -y \
    && cd /opt && git clone https://github.com/jetspeed/Raneto \
    && npm install --global gulp-cli pm2

# Entering into the Raneto directory
WORKDIR $RANETO_INSTALL_DIR

# Installing Raneto
RUN npm install \
    && rm -f $RANETO_INSTALL_DIR/example/config.default.js \
    && rm -rf $RANETO_INSTALL_DIR/node_modules/lunr 
COPY lunr $RANETO_INSTALL_DIR/node_modules/lunr 
RUN  gulp &&rm -rf /var/cache/apt/* 

# Exposed the raneto default port 3000
EXPOSE 3000

# Starting the raneto
CMD [ "pm2", "start", "/opt/Raneto/example/server.js", "--name", "raneto", "--no-daemon" ]
