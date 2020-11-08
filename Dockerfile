FROM debian:buster

# add support for gpio library
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y tcl curl && curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs

# Home directory for Node-RED application source code.
RUN mkdir -p /usr/src/node-red

# User data directory, contains flows, config and nodes.
RUN mkdir /data

WORKDIR /usr/src/node-red

# Add node-red user so we aren't running as root.
RUN useradd --home-dir /usr/src/node-red --no-create-home node-red \
    && chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red \
    && mkdir -p /usr/local/bin/ && mkdir -p /usr/local/lib/node_modules

RUN npm install -g npm  && chmod 4711 /bin/ping && chmod 4711 /bin/ping6

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/
USER node-red
RUN npm install

# copy the gruenbeck tclsh command to /usr/local/bin
COPY get_gruenbeck.tcl /usr/local/bin/

# User configuration directory volume
EXPOSE 1880

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json
ENV NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules

CMD ["npm", "start", "--", "--userDir", "/data"]

