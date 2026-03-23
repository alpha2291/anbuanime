FROM node:20-bullseye-slim as builder
LABEL version="1.0.0"
LABEL description="Gogoanime API docker image"
LABEL org.opencontainers.image.source https://github.com/riimuru/gogoanime

RUN apt-get update && apt-get upgrade -y && apt-get autoclean -y && apt-get autoremove -y

RUN groupadd -r nodejs && useradd -g nodejs -s /bin/bash -d /home/nodejs -m nodejs
USER nodejs

RUN mkdir -p /home/nodejs/app/node_modules && chown -R nodejs:nodejs /home/nodejs/app
WORKDIR /home/nodejs/app

ARG NODE_ENV=production
ARG PORT=10000

ENV NODE_ENV=${NODE_ENV}
ENV PORT=${PORT}
ENV NPM_CONFIG_LOGLEVEL=warn

COPY --chown=nodejs:nodejs package*.json ./

RUN npm install && npm cache clean --force

COPY --chown=nodejs:nodejs . .

EXPOSE 10000

CMD [ "npm", "start" ]
