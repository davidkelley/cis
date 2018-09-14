FROM debian:wheezy-slim

VOLUME /tmp

RUN apt-get update && \
    apt-get install -y bc apparmor apparmor-utils

RUN apt-get install -y libpam-cracklib openssh-server syslog-ng auditd iptables

ADD debian-cis /opt/cis

ADD conf.d /opt/cis/etc/conf.d

RUN echo 'GRUB_CMDLINE_LINUX="audit=1"' >> /etc/default/grub

RUN cd /opt/cis && \
    cp debian/default /etc/default/cis-hardening && \
    sed -i "s#CIS_ROOT_DIR=.*#CIS_ROOT_DIR='$(pwd)'#" /etc/default/cis-hardening && \
    bin/hardening.sh --apply
