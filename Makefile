# username to create in installed sytem
USR=$(shell whoami)
# hostname to use for container
HST=$(shell hostname)-docker
BASENAME=devenv
# image name to use when building
IMAGE=$(BASENAME):$(USR)

BINHOME=$(HOME)/.local/bin
BINPATH=$(BINHOME)/$(BASENAME)-up.sh

build:
	$(info Starting build...)
	$(info USER: $(USR))
	$(info IMAGE NAME: $(IMAGE))
	$(info HOST NAME: $(HST))
	docker build \
		--build-arg USERNAME=$(USR) \
		-t $(IMAGE) \
		-f Dockerfile .

run: 
	docker run -it --rm -v $(shell pwd):/mnt -h $(HST) $(IMAGE)

install:
	$(info Installing to $(BINPATH))
	mkdir -p $(BINHOME)
	echo 'docker run -it --rm -v $$(pwd):/mnt -h $(HST) $(IMAGE)' > $(BINPATH)
	chmod +x $(BINPATH)
	ls -l $(BINPATH)
	$(info Done...)

all: build install

