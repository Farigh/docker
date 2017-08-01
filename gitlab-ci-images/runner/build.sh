#! /bin/bash

docker_image_name=gitlab-ci-runner

docker build -t $docker_image_name --rm image/
