FROM node:18-alpine

WORKDIR /app

RUN chown -R node:node /app

COPY package*.json .

RUN chown -R node:node .

USER node

RUN npm install

RUN npm install http-server

COPY --chown=node:node . .

RUN npm run build

CMD npx http-server dist
