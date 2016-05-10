#! /bin/bash

docker_image_name=ubuntu-sshd

docker build -t $docker_image_name --rm image/
