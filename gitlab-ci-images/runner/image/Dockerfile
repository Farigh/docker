FROM ubuntu:17.04
MAINTAINER GARCIN David <david.garcin.pro@gmail.com>

ADD configure.sh /configure
RUN chmod +x /configure
RUN /configure

ADD start.sh /start
RUN chmod +x /start

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/start"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
