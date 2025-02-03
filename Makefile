REGISTRY = docker.io
IMG_NAMESPACE = asteven
IMG_NAME = redmine-lifecycle-bot
IMG_FQNAME = $(REGISTRY)/$(IMG_NAMESPACE)/$(IMG_NAME)
IMG_VERSION = 0.1.3
# Prefere podman over docker for building.
BUILDER = $(shell which podman || which docker)


.PHONY: container push clean
all: container

container:
	$(BUILDER) build --pull \
		--tag $(IMG_FQNAME):$(IMG_VERSION) \
		--tag $(IMG_FQNAME):latest .

push:
	$(BUILDER) push $(IMG_FQNAME):$(IMG_VERSION) docker://$(IMG_FQNAME):$(IMG_VERSION)
	# Also update :latest
	$(BUILDER) push $(IMG_FQNAME):latest docker://$(IMG_FQNAME):latest

clean:
	$(BUILDER) rmi $(IMG_FQNAME):$(IMG_VERSION) || true
	$(BUILDER) rmi $(IMG_FQNAME):latest || true

