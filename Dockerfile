FROM language-zoo:latest

LABEL maintainer="Michele Adduci <adduci@tutanota.com>" \
      license="Copyright (c) 2012-2021, Matt Godbolt"

EXPOSE 10240

RUN echo "*** Installing Compiler Explorer ***" \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y \
        wget \
        ca-certificates \
        nodejs \
        make \
        git \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/* \
    && git clone https://github.com/compiler-explorer/compiler-explorer.git /compiler-explorer \
    && cd /compiler-explorer \
    && echo "Add missing dependencies" \
    && npm i @sentry/node \
    && make webpack

ADD c++.properties /compiler-explorer/etc/config/c++.local.properties

RUN echo "Adding rust support to ce" \
    && cargo install rustfilt

ADD rust.properties /compiler-explorer/etc/config/rust.local.properties

WORKDIR /compiler-explorer

ENTRYPOINT [ "make" ]

CMD ["run"]
