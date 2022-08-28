FROM ubuntu:22.04 AS ubuntu

# create unprivileged user
ARG USERNAME
ARG GID
ARG UID

# adding group and user with specific IDs
# so that this user could simply mount their 
# home dir and use if with the image
RUN groupadd --gid ${GID} ${USERNAME}
RUN useradd -m -d /home/${USERNAME} \
--uid ${UID} \
-s /bin/bash \
-g ${USERNAME} \
-G ${USERNAME},users,sudo,root ${USERNAME}

# switch to unprivileged user 
USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD ["bash"]
