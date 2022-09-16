FROM ubuntu:22.04 AS ubuntu

# installing stuff
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y sudo curl wget 

# installing dev stuff
RUN apt-get install -y --no-install-recommends git make golang neovim

# cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# create unprivileged user
ARG USERNAME
ARG GID
ARG UID

# adding group and user with specific IDs
# so that this user could simply mount their 
# home dir and use it with the image
RUN groupadd --gid ${GID} ${USERNAME}
RUN useradd -m -d /home/${USERNAME} \
--uid ${UID} \
-s /bin/bash \
-g ${USERNAME} \
-G ${USERNAME},users,sudo,root ${USERNAME}

# let all users run sudo without password
RUN sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'

# switch to unprivileged user 
USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD ["bash"]
