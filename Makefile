# username to create in installed sytem
USR=$(shell whoami)

# hostname to use for container
HST=$(shell hostname)-docker

DOCKER_UID=$(shell id -u)
DOCKER_GID=$(shell id -g)

#image basename
BASENAME=devenv

# image name to use when building
IMAGE=$(BASENAME):$(USR)

# path to local directory to put run script
BINHOME=$(HOME)/.local/bin

# full path to run script
BINPATH=$(BINHOME)/$(BASENAME)-up.sh

build:
	$(info Starting build...)
	$(info USER: $(USR))
	$(info IMAGE NAME: $(IMAGE))
	$(info HOST NAME: $(HST))
	docker build \
		--build-arg USERNAME=$(USR) \
		--build-arg UID=$(DOCKER_UID) \
		--build-arg GID=$(DOCKER_GID) \
		-t $(IMAGE) \
		-f Dockerfile .

run: 
	docker run -it --rm -v $(shell pwd):/mnt -h $(HST) $(IMAGE)

install:
	$(info Installing to $(BINPATH))
	set -e
	mkdir -p $(BINHOME)
	echo 'docker run -it --rm -v $(HOME):/home/$(USR) -h $(HST) $(IMAGE)' > $(BINPATH)
	chmod +x $(BINPATH)
	ls -l $(BINPATH)
	$(info Done...)
	$(info You can now command $(BINPATH) to run your container)

all: build install

