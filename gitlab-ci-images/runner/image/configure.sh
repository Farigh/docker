#! /bin/bash

docker_machine_version=0.13.0
dumb_init_version=1.2.0

# Install needed packages
apt-get update -y
apt-get upgrade -y
apt-get install -y ca-certificates curl apt-transport-https vim nano lsb-release

# Add dumb-init
curl -fsSL https://github.com/Yelp/dumb-init/releases/download/v${dumb_init_version}/dumb-init_${dumb_init_version}_amd64 > /usr/bin/dumb-init
chmod -R 700 /usr/bin/dumb-init

# Add gitlab-ci-multi-runner to source list
current_ubuntu_version_name=$(lsb_release -cs)
echo "deb https://packages.gitlab.com/runner/gitlab-ci-multi-runner/ubuntu/ ${current_ubuntu_version_name} main" > /etc/apt/sources.list.d/runner_gitlab-ci-multi-runner.list
curl -fsSL https://packages.gitlab.com/gpg.key | apt-key add -

# Install gitlab stuff
apt-get update -y
apt-get install -y gitlab-ci-multi-runner

# Install docker machine
curl -fsSL https://github.com/docker/machine/releases/download/v${docker_machine_version}/docker-machine-Linux-x86_64 > /usr/bin/docker-machine
chmod +x /usr/bin/docker-machine
mkdir -p /etc/gitlab-runner/certs
chmod -R 700 /etc/gitlab-runner

# Clean up APT when done.
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
