#! /bin/bash

docker_image_name=gitlab-ci-cpp-agent

docker build -t $docker_image_name --rm image/
