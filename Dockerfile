FROM ubuntu:20.04

ENV TZ Japan
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8
RUN apt-get update \
  && apt-get install -y apt-utils tzdata locales locales-all language-pack-ja-base language-pack-ja sudo bash\
  && rm -rf /var/lib/apt/lists/* \
  && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && locale-gen ja_JP.UTF-8 \
  && sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen \
  && localedef -f UTF-8 -i ja_JP ja_JP.utf8 \
  && echo -e 'LANG="ja_JP.UTF-8"\nLANGUAGE="ja_JP:en"\n' > /etc/default/locale \
  && dkpg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=$LANG


RUN curl -sL https://github.com/basd4g/mopm/releases/download/0.0.2/mopm-amd64-linux.out > /usr/bin/mopm && chmod a+x /usr/bin/mopm

RUN useradd --uid 1001 --create-home --shell /bin/bash -G sudo,root --password mopmuser mopmuser
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/mopmuser/.mopm && chown mopmuser /home/mopmuser && chown mopmuser /home/mopmuser/.mopm

USER mopmuser
WORKDIR /home/mopmuser
COPY . /home/mopmuser/.mopm/repos/github.com/basd4g/mopm-defs
RUN echo 'https://github.com/basd4g/mopm-defs' > /home/mopmuser/.mopm/repos-url

ENTRYPOINT ["sudo", "mopm", "install"]
