FROM debian:bullseye-slim

RUN apt-get update \
 && apt-get install --no-install-recommends -y ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && update-ca-certificates

RUN adduser --gecos ""  --disabled-password --home /app appuser

USER appuser
COPY --chown=appuser . /app
COPY ./libhg.so* /usr/lib/
ENV LD_LIBRARY_PATH=/usr/lib
WORKDIR /app

ENTRYPOINT ["./honeygain"]
