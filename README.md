# devenv
**devenv** is a tool to quickly build a Docker image based on Ubuntu 22.04 with
easily customisable set of packages. The image is built with an entrypoint script
which lets you set up an unprivileged user in container OS. 

The whole story is intended for developers needing to experiment with different
versions of build tools etc.

## Customise
1. Customize packages that you want to install into the
container OS. Just edit the **packages.list** putting
one package name per line.

2. Add shell scripts or binaries to **./custom** directory. These 
will run at build time as **root** and the produced result will be 
baked into the image.

3. **(optional)** edit Makefile, Dockerfile, entrypoint.sh accoriding
to your requirements.

## Build the image
This builds Docker image with Ubuntu 22.04 as base
installing the tools you chose above. Note that build 
executes all scripts in **./scripts** directory if any are present.
```bash
make build
```
## Entrypoint
Entrypoint script creates an unprivileged user in container system.
Username, gid and uig can be altered when launching the container by passing environment
variables to docker run.

If no environment variables were passed to docker run, the unprivileged user will
default to **developer:developer** with uig/gid **1001:1001**.

By default the user has passwordless sudo.

## Create launch script
This will create a bash script that runs the container from the image 
built above with your current username, uid and gid. Since username, uid and 
gid are the same as in your host system you can safely mount anything from 
your host system into container without creating mess in host OS.

By default the launch script mounts your home directory into the unprivileged 
user's home in the container. Edit as approprite.
```bash
make script
```

## Create and install launch script
This will create the launch script (see above) and place it into you
$HOME/.local/bin creating the directory is it does not exist.
```bash
make install 
```
