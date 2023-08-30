FROM ruby:3.1.0

ARG RONIN_UID=1000
ARG RONIN_GID=1000

ENV LANG=en_US.UTF-8

WORKDIR /app
ADD Gemfile /app
ADD gemspec.yml /app
ADD lib/ronin/app/version.rb /app/lib/ronin/app/
ADD ronin-app.gemspec /app

ARG NMAP_CAPS=cap_net_raw,cap_net_admin,cap_net_bind_service
ARG MASSCAN_CAPS=cap_net_raw,cap_net_admin,cap_net_bind_service

RUN apt-get update &&\
    apt-get install -qq -y libcap2-bin gcc g++ make libsqlite3-dev nmap masscan && \
    setcap "${NMAP_CAPS}+eip" /usr/bin/nmap && \
    setcap "${MASSCAN_CAPS}+eip" /usr/bin/masscan && \
    bundle install --path /app/vendor/bundler

ADD . /app

RUN groupadd -g "${RONIN_GID}" ronin && \
    useradd -u "${RONIN_UID}" -g ronin -ms /bin/bash ronin
USER ronin
