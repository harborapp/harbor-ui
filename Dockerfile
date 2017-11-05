FROM alpine:edge

EXPOSE 9000 80 443
VOLUME ["/var/lib/umschlag"]

RUN apk update && \
  apk add \
    ca-certificates \
    bash && \
  rm -rf \
    /var/cache/apk/* && \
  addgroup \
    -g 1000 \
    umschlag && \
  adduser -D \
    -h /var/lib/umschlag \
    -s /bin/bash \
    -G umschlag \
    -u 1000 \
    umschlag

COPY dist/static /usr/share/umschlag

ARG VERSION
COPY dist/binaries/umschlag-ui-master-linux-amd64 /usr/bin/

ENV UMSCHLAG_UI_ASSETS /usr/share/umschlag
ENV UMSCHLAG_UI_STORAGE /var/lib/umschlag

LABEL maintainer="Thomas Boerger <thomas@webhippie.de>"
LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.name="Umschlag UI"
LABEL org.label-schema.vendor="Thomas Boerger"
LABEL org.label-schema.schema-version="1.0"

USER umschlag
ENTRYPOINT ["/usr/bin/umschlag-ui"]
CMD ["server"]
