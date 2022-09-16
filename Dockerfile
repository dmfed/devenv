FROM ubuntu:22.04 AS ubuntu

# setting non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# update system and install very basic stuff
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
sudo curl wget openssh-client ca-certificates tzdata

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

# at last create unprivileged user
# username and gid/uid can be redefined
# at build time
# if IDs match local users ones then local 
# users home dir can be mounted into the image
ARG USERNAME=developer
ARG GID=1001
ARG UID=1001

RUN groupadd --gid ${GID} ${USERNAME} && \
    useradd -m -d /home/${USERNAME} \
    --uid ${UID} \
    -s /bin/bash \
    -g ${USERNAME} \
    -G ${USERNAME},users,sudo,root ${USERNAME} && \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'

# switch to unprivileged user 
USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD ["bash"]
