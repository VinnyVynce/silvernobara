FROM docker.io/fedora:37

MAINTAINER VinnyVynce (https://github.com/VinnyVynce)

# Execute as root
USER root

# Updating container
RUN dnf update -y && dnf install -y git cronie rpm-ostree selinux-policy selinux-policy-targeted policycoreutils

# Setting workdir
WORKDIR /ostree

# Arguments for rpm-ostree 
ARG repo=/repo

# Create a startup script to keep the github repo in sync.
RUN echo '#!/bin/bash' > /tmp/start.sh && \
    echo 'cd /ostree' >> /tmp/start.sh && \
    echo 'if [ -f "/ostree/build.sh" ]; then' >> /tmp/start.sh && \
    echo '  git pull' >> /tmp/start.sh && \
    echo 'else' >> /tmp/start.sh && \
    echo '  git clone https://github.com/VinnyVynce/silvernobara .' >> /tmp/start.sh && \
    echo 'fi' >> /tmp/start.sh && \
    echo 'chmod u+x /ostree/build.sh' >> /tmp/start.sh && \
    echo '/bin/bash /ostree/build.sh' >> /tmp/start.sh && \
    mkdir -p /tmp/cache /tmp/repo && chmod u+x /tmp/start.sh

# Create crontab
RUN touch /var/log/cron.log
RUN echo "0 */3 * * * root  /tmp/start.sh  >> /var/log/cron.log 2>&1" >> /etc/crontab

# Run the command on container startup
ENTRYPOINT ["/usr/sbin/crond", "-n"]
