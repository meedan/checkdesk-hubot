# hubot, for fun and profit

FROM node:latest
MAINTAINER sysops@meedan.com
ENV IMAGE meedan/checkbot
ENV DEPLOYUSER checkbot
ENV DEPLOYDIR /opt/checkbot
ENV BOTNAME checkbot

RUN apt-get update --fix-missing
RUN apt-get -qy install git-core redis-server supervisor

RUN mkdir -p /var/log/supervisor
ADD ./docker/config/supervisor /etc/supervisor/conf.d

RUN useradd ${DEPLOYUSER} -s /bin/bash -m
RUN chown -R ${DEPLOYUSER}:${DEPLOYUSER} /home/${DEPLOYUSER}

RUN mkdir -p $DEPLOYDIR
RUN chown ${DEPLOYUSER}:${DEPLOYUSER} ${DEPLOYDIR}

RUN npm install -g yo generator-hubot coffee-script
USER $DEPLOYUSER
RUN mkdir $DEPLOYDIR/${BOTNAME}
WORKDIR $DEPLOYDIR/${BOTNAME}

# these are on the same line due to a conflict between npm and docker
# due to node's `fs` module not being able to go across "devices" which in this case are actually docker image layers 
# https://groups.google.com/d/msg/meteor-talk/_WFeZUZQCqY/h7_SIhLuaWAJ
RUN yo hubot --owner="#sysops <sysops@meedan.com>" --name="${BOTNAME}" --description="meedan's checkbot" --adapter=slack  --defaults && npm install --save hubot-slack cheerio
	
COPY external-scripts.json $DEPLOYDIR/${BOTNAME}/external-scripts.json
COPY hubot-scripts.json $DEPLOYDIR/${BOTNAME}/hubot-scripts.json
COPY scripts $DEPLOYDIR/${BOTNAME}/scripts

USER root
CMD ["supervisord", "-n"]

