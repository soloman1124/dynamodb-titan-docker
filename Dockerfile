FROM maven:3.3.3-jdk-8
MAINTAINER Soloman Weng "soloman1124@gmail.com"
ENV REFRESHED_AT 2016-05-11

ENV GREMLIN_PORT 8182

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update
RUN apt-get install git zip -y
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/awslabs/dynamodb-titan-storage-backend.git /usr/src/app

RUN mvn install
RUN /usr/src/app/src/test/resources/install-gremlin-server.sh \
    && rm /usr/src/app/server/dynamodb-titan100-storage-backend-1.0.0-hadoop1.zip

WORKDIR /usr/src/app/server/dynamodb-titan100-storage-backend-1.0.0-hadoop1

EXPOSE $GREMLIN_PORT

ENTRYPOINT /bin/bash
