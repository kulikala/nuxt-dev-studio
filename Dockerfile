FROM node:12-alpine

RUN apk --update add git openssh && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/*

WORKDIR /app

EXPOSE 3000

COPY ./templates /templates
COPY ./tools /tools

ENV HOST 0.0.0.0
ENTRYPOINT ["/tools/studio.sh"]

ONBUILD ARG AUTO_BUILD=yes
ONBUILD ENV AUTO_BUILD ${AUTO_BUILD}

ONBUILD COPY . /app
ONBUILD WORKDIR /app
ONBUILD RUN npm install; \
            if [ "${AUTO_BUILD}" = "yes" ]; then \
                ./node_modules/.bin/nuxt build; \
            fi

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=1.1

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="nuxt-dev-studio" \
      org.label-schema.description="Easy to use, all in one Nuxt.js development environment" \
      org.label-schema.url="https://github.com/kulikala/nuxt-dev-studio" \
      org.label-schema.vcs-url="git@github.com:kulikala/nuxt-dev-studio.git" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vendor="Kaz Namba" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0" \
      maintainer="Kaz Namba <kaz.namba@gmail.com>" \
      version=${VERSION}

CMD ["npm", "start"]
