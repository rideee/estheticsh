FROM fedora:latest

RUN dnf -y update && \
    dnf -y install swiftlang

WORKDIR /app/

COPY . .

RUN swift --version