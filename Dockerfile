FROM alpine:edge as alpine
RUN apk add --no-cache ca-certificates mailcap

FROM scratch

EXPOSE 9000 80 443
VOLUME ["/var/lib/umschlag"]

ENV UMSCHLAG_UI_ASSETS /usr/share/umschlag
ENV UMSCHLAG_UI_STORAGE /var/lib/umschlag

ENTRYPOINT ["/usr/bin/umschlag-ui"]
CMD ["server"]

COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=alpine /etc/mime.types /etc/

COPY dist/static /usr/share/umschlag

ARG VERSION
COPY dist/binaries/umschlag-ui-$VERSION-linux-amd64 /usr/bin/

LABEL maintainer="Thomas Boerger <thomas@webhippie.de>"
LABEL org.label-schema.version=$VERSION
LABEL org.label-schema.name="Umschlag UI"
LABEL org.label-schema.vendor="Thomas Boerger"
LABEL org.label-schema.schema-version="1.0"
