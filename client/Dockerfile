FROM node:18-alpine as build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# ----

FROM nginx:stable-alpine as production
ARG API_URL

COPY --from=build /app/dist /usr/share/nginx/html

COPY default.conf /etc/nginx/conf.d/default.conf

RUN sed -i "s#__API_URL__#${API_URL}#g" /etc/nginx/conf.d/default.conf 

EXPOSE 80

CMD nginx -g 'daemon off;'
