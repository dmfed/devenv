# get username
USR=$(shell whoami)

#image basename
BASENAME=devenv
IMAGE_NAME=$(BASENAME):$(USR)

# path to local directory to put run script
BINHOME=$(HOME)/.local/bin

# full path to run script
RUN_SCRIPT_PATH=$(BINHOME)/$(BASENAME)-$(USR)-up.sh

build:
	$(info BUILDING IMAGE NAME: $(IMAGE_NAME))
	docker build \
		-t $(IMAGE_NAME) \
		-f Dockerfile .
	docker image ls $(IMAGE_NAME)

run: 
	docker run -it --rm -v $(shell pwd):/mnt -h $(shell hostname)-docker $(IMAGE_NAME)

install:
	$(info installing script to $(RUN_SCRIPT_PATH))
	set -e
	mkdir -p $(BINHOME)
	echo 'docker run -it --rm \
		-v $$HOME:/home/$(USR) \
		-h $$(hostname)-docker \
		--env USERNAME=$$(whoami) \
		--env GID=$$(id -g) \
		--env UID=$$(id -u) \
		$(IMAGE_NAME)' > $(RUN_SCRIPT_PATH)
	chmod +x $(RUN_SCRIPT_PATH)
	ls -l $(RUN_SCRIPT_PATH)

all: build install

