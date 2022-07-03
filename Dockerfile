FROM docker.io/fedora:36

MAINTAINER VinnyVynce (https://github.com/VinnyVynce)

# Execute as root
USER root

# Updating container
RUN dnf update -y && dnf install -y git cronie rpm-ostree selinux-policy selinux-policy-targeted policycoreutils

# Setting workdir
WORKDIR /ostree

# Arguments for rpm-ostree 
ARG repo=/repo

# Clone repository and change execution permissions for build.sh
RUN git clone https://github.com/VinnyVynce/silvernobara . && mkdir -p /tmp/cache /tmp/repo && chmod u+x build.sh /entry.sh

# Create crontab
RUN touch /var/log/cron.log
RUN echo "* */3 * * * root  /ostree/build.sh >> /var/log/cron.log 2>&1" >> /etc/crontab

# Run the command on container startup
ENTRYPOINT ["/usr/sbin/crond", "-n"]
