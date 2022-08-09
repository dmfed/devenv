FROM ubuntu:22.04 AS ubuntu

# create unprivileged user
ARG USERNAME
RUN groupadd ${USERNAME}
RUN useradd -m -d /home/${USERNAME} -s /bin/bash -g ${USERNAME} -G ${USERNAME},users,sudo,root ${USERNAME}

# switch to unprivileged user 
USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD ["bash"]
