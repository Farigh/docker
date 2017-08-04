#! /bin/bash

# Install needed packages
apt-get update -y
apt-get upgrade -y
apt-get install -y gcc make g++

# Clean up APT when done.
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
