FROM node:6.14.4-alpine

LABEL maintainer="adi_gunawan@live.com"

ENV HUGO_VERSION=0.48
ENV HUGO_DOWNLOAD_URL=https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz
ENV GLIBC_VERSION 2.27-r0

RUN apk add --update --no-cache --virtual build-dependencies

RUN apk add --update --no-cache \
		bash \
		build-base \
		ca-certificates \
    libstdc++ \
		curl \
		git \
		libcurl \
# Needed for Hugo Extended which uses CGO
		libc6-compat \
		libxml2-dev \
		libxslt-dev \
		openssh \
		rsync \
		wget

# Install glibc

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
&&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk" \
&&  apk --no-cache add "glibc-$GLIBC_VERSION.apk" \
&&  rm "glibc-$GLIBC_VERSION.apk" \
&&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-bin-$GLIBC_VERSION.apk" \
&&  apk --no-cache add "glibc-bin-$GLIBC_VERSION.apk" \
&&  rm "glibc-bin-$GLIBC_VERSION.apk" \
&&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-i18n-$GLIBC_VERSION.apk" \
&&  apk --no-cache add "glibc-i18n-$GLIBC_VERSION.apk" \
&&  rm "glibc-i18n-$GLIBC_VERSION.apk"

RUN wget "$HUGO_DOWNLOAD_URL" && \
	tar xzf hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
	mv hugo /usr/bin/hugo && \
	rm hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz LICENSE README.md

CMD ["hugo","version"]

EXPOSE 1313
