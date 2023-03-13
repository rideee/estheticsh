FROM swift:latest

RUN apt-get update && \
    apt-get -y install docker

WORKDIR /app/

COPY . .
