[![Docker Size](https://images.microbadger.com/badges/image/farigh/minimalist-sshd.svg)](https://hub.docker.com/r/farigh/minimalist-sshd/) [![Docker Pulls](https://img.shields.io/docker/pulls/farigh/minimalist-sshd.svg)](https://hub.docker.com/r/farigh/minimalist-sshd/) [![Docker Stars](https://img.shields.io/docker/stars/farigh/minimalist-sshd.svg?maxAge=2592000)](https://hub.docker.com/r/farigh/minimalist-sshd/)

# Minimalist sshd

This docker minimalist sshd image is meant to easily increase your security adding an intermediary step before being able to connect to your server.

To simply use the latest stable version, run

    docker run --cap-add=NET_ADMIN -d -p 22:22 -v <path_to_host_dir>:/home/sshuser --name ubuntu-sshd farigh/minimalist-sshd

where the standard sshd port, 22, will be exposed on your host and the directory <path_to_host_dir> mounted as the container user's home dir.

## Configuring the container

This image is configured as follows:
  * Disabled root login
  * Enabled RSA host auth
  * Disabled password auth
  * Disabled display forwarding
  * Disabled PAM module

You might have noticed the

    -v <path_to_host_dir>:/home/sshuser

option in the first command provided. This allow you to mount a directory from the host onto the container's user home directory.

### Adding an SSH key

An ssh key is needed to log into this container.
You must create a `.ssh` dir in the <path_to_host_dir>, then create a `authorized_keys2` file within the .ssh  directory.
Finally add your ssh key to this file.

### Prevent history recording

For a more secure environment, I suggest you create a `.profile` file in the mounted dir and add the following content to it:

    #! /bin/bash

    shopt -u -o history

This will prevent command history recording.

You should have the following tree:
```
/path/on/host
├── .ssh
│   └── authorized_keys2
│   └── known_hosts   [Will be created automatically]
├── .profile
└── ...
```

### Changing the host port

If you want to use an alternate port, changing the host-side port mapping such as

    docker run -p 42000:22 ...

will serve your sshd service on your host's port 42000 since the `-p` syntax is `host-port`:`container-port`.
