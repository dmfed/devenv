# get username
USR=$(shell whoami)

#image basename
BASENAME=devenv
IMAGE_NAME=$(BASENAME):$(USR)

# path to local directory to put run script
BINHOME=$(HOME)/.local/bin

# full path to run script
RUN_SCRIPT_NAME=$(BASENAME)-$(USR)-up.sh

build:
	$(info BUILDING IMAGE NAME: $(IMAGE_NAME))
	docker build \
		-t $(IMAGE_NAME) \
		-f Dockerfile .
	docker image ls $(IMAGE_NAME)

script: 
	$(info creating run script $RUN_SCRIPT_NAME)
	echo 'docker run -it --rm \
		-v $$HOME:/home/$(USR) \
		-h $$(hostname)-docker \
		--env USERNAME=$$(whoami) \
		--env GID=$$(id -g) \
		--env UID=$$(id -u) \
		$(IMAGE_NAME)' > ./$(RUN_SCRIPT_NAME)
	chmod +x $(RUN_SCRIPT_NAME)

install: script
	$(info installing script to $(BINHOME)/$(RUN_SCRIPT_NAME))
	set -e
	mkdir -p $(BINHOME)
	mv $(RUN_SCRIPT_NAME) $(BINHOME)
	ls -l $(BINHOME)/$(RUN_SCRIPT_NAME)

all: build install

