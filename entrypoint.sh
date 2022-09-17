# devenv enrypoint script creates user 
# and group then creates home directory
# and substitutes current user (root)
# with specified user.
# environment variables default to user
# developer 1001:1001 as specified in 
# Dockerfile and can be overriden by
# docker run --env USERNAME=someuser
# --env GID=2000 etc.
set -e
groupadd --gid $GID $USERNAME
useradd --uid $UID \
    -s /bin/bash \
    -g $USERNAME \
    -G $USERNAME,users,sudo $USERNAME 

# make sure unprivileged users will have passwordless sudo
sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g'

# create home dir and cd into it
mkdir -p /home/$USERNAME && cd /home/$USERNAME

# switch to unprivileged user
exec gosu $USERNAME:$USERNAME $@
