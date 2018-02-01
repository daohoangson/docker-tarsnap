FROM alpine:3.7

ENV TARSNAP_VERSION 1.0.39-r2

RUN apk add --no-cache \
    tarsnap=${TARSNAP_VERSION}

VOLUME ["/tarsnap", "/usr/local/etc"]

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/tarsnap", "--help"]
