FROM docker.io/fedora:36

MAINTAINER VinnyVynce (https://github.com/VinnyVynce)

# Execute as root
USER root

# Updating container
RUN dnf update -y && dnf install -y git cronie rpm-ostree selinux-policy selinux-policy-targeted policycoreutils

# Setup cron for auto updating Fedora
ADD crontab /etc/cron.d/updateRepo
RUN chmod 0644 /etc/cron.d/updateRepo
RUN touch /var/log/cron.log

# Copy startup script
COPY entry.sh /entry.sh

# Setting workdir
WORKDIR /ostree

# Arguments for rpm-ostree 
ARG repo=/repo
ARG cache=/tmp

# Clone repository and change execution permissions for build.sh
RUN git clone https://github.com/VinnyVynce/silvernobara . && mkdir -p /tmp/cache /tmp/repo && chmod u+x build.sh /entry.sh

# Run the command on container startup
CMD ["/entry.sh"]
