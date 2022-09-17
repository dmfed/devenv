FROM ubuntu:22.04 AS ubuntu

# setting non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# update system and install the required stuff
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
gosu sudo 

# install packages appearing in packages.list
# clean up chache and remove package lists
COPY ./packages.list /tmp
RUN xargs apt-get install -y --no-install-recommends </tmp/packages.list && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* && \
rm /tmp/packages.list


# copy and run scripts from custom directory
# which are intended to install and bake something
# into the image which we can not install via 
# package manager
COPY ./build_time_scripts.sh /tmp
COPY ./custom /tmp/custom
RUN /tmp/build_time_scripts.sh /tmp/custom && \
rm -rf /tmp/build_time_scripts.sh /tmp/custom

# at last set unprivileged user username and gid/uid 
# these will be picked by entrypoint script at run time
# and user with specified uig/gid will be created.
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
