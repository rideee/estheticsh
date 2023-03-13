#!/usr/bin/env bash
#
# Docker swift shortcut script.

docker run -v "$PWD:/code" -w /code --platform linux/amd64 -e QEMU_CPU=max swift:latest $@