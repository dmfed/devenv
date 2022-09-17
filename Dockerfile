FROM ubuntu:22.04 AS ubuntu

# setting non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# update system and install very basic stuff
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
gosu sudo curl wget openssh-client ca-certificates tzdata

# install basic dev stuff
RUN apt-get install -y --no-install-recommends git make build-essential

# PUT YOUR PACKAGES OF CHOICE HERE
RUN apt-get install -y --no-install-recommends neovim

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# install vanilla Go 1.18.6
RUN curl --location https://go.dev/dl/go1.18.6.linux-amd64.tar.gz -o /tmp/go.tar.gz && \
tar -xzvf /tmp/go.tar.gz -C /usr/local && \
rm /tmp/go.tar.gz && \
ln -s /usr/local/go/bin/* /usr/bin

# at last set unprivileged user username and gid/uid 
# these will be picked by entrypoint script at run time
# and user with cpecified uig/gid will be created 
# these can be redefined with 
# docker run --env USERNAME=myuser etc.
ENV USERNAME=developer
ENV GID=1001
ENV UID=1001

# copy enrypoint script
COPY ./entrypoint.sh /usr/bin/entrypoint-docker.sh

# run entrypoint script
ENTRYPOINT ["/bin/sh", "/usr/bin/entrypoint-docker.sh"]
CMD ["/usr/bin/bash"]
