FROM node:18
ARG CLIENT_URL

WORKDIR /app

COPY package*.json .

# @TMP solution for /could not locate the Query Engine for runtime "linux-musl"/
COPY prisma ./prisma

RUN chown -R node:node .

USER node

RUN npm install

COPY --chown=node:node . .

RUN sed -i "s#ORIGIN_WHITELIST=.*#ORIGIN_WHITELIST=${CLIENT_URL}#g" .env

CMD node ./src/index.js
