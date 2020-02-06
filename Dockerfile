FROM ubuntu:18.04

LABEL maintainer="Paolo Smiraglia" \
      maintainer.email="paolo.smiraglia@gmail.com"

RUN apt-get update \
    && apt-get install -y \
        openssl \
        xxd

COPY ./rootfs/ /
RUN chmod +x /usr/local/bin/look4qwac.sh

ENTRYPOINT ["/usr/local/bin/look4qwac.sh"]

# vim: ft=dockerfile
