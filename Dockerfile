###############################################################################
# BUILD
###############################################################################
FROM node:9.8.0-alpine as builder

RUN apk update \
&& apk add python2 \
&& mkdir -p /usr/src/angular

WORKDIR /usr/src/app

COPY src/node/package.json /usr/src/app/

RUN npm config set user 0 \
&& npm config set unsafe-perm true \
&& npm install

COPY src/node/ /usr/src/app/

WORKDIR /usr/src/angular

COPY src/angular/package.json /usr/src/angular/

RUN npm install

COPY src/angular/ /usr/src/angular/

RUN npm install -g @angular/cli@1.7.3 \
&& ng build --env=prod





###############################################################################
# FINAL
###############################################################################
FROM node:9.8.0-alpine

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app .

EXPOSE 3000

CMD ["npm", "start"]
