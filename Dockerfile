FROM ubuntu:latest
WORKDIR /work
COPY ./work .

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata sudo vim \
    && rm -rf /var/lib/apt/lists/*

RUN TZ=Asia/Taipei \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install vim -y