FROM node:20

WORKDIR /app

ENV NPM_CONFIG_LOGLEVEL warn
COPY ./package.json ./
RUN npm install --production

RUN npx playwright install --with-deps chromium

COPY ./app.js ./

RUN ls -al

ENTRYPOINT [ "node" ]
CMD [ "app.js" ]
