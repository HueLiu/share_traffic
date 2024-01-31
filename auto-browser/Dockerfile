FROM node:20

WORKDIR /app

ENV NPM_CONFIG_LOGLEVEL warn
COPY ./package.json ./
RUN npm install --production
RUN npm install pm2 -g

RUN npx playwright install --with-deps chromium

COPY ./app.js ./
RUN mkdir data

RUN ls -al

ENTRYPOINT [ "pm2-runtime" ]
CMD [ "start pm2.json" ]
