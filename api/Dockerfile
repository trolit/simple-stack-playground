FROM node:18

WORKDIR /app

COPY package*.json .

# @TMP solution for /could not locate the Query Engine for runtime "linux-musl"/
COPY prisma ./prisma

RUN chown -R node:node .

USER node

RUN npm install

COPY --chown=node:node . .

CMD node ./src/index.js
