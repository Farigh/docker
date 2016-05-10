FROM ubuntu:16.04
MAINTAINER GARCIN David <david.garcin.pro@gmail.com>

ADD configure.sh /configure

RUN /configure

ADD start.sh /start

VOLUME ["/home/sshuser"]

EXPOSE 22
CMD ["/start"]
