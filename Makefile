IMAGE_NAME = kulikala/nuxt-dev-studio
TAG_NAME = latest

default: build

build:
	docker image build \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		-t $(IMAGE_NAME):$(TAG_NAME) \
		.

push:
	docker image push \
		$(IMAGE_NAME):$(TAG_NAME)

debug:
	docker container run \
		--entrypoint /bin/ash \
		--interactive \
		--name nuxt-dev-studio \
		--publish 3000:3000 \
		--rm \
		--tty \
		--volume "$(PWD):/app" \
		$(IMAGE_NAME):$(TAG_NAME)

run:
	docker container run \
		--interactive \
		--name nuxt-dev-studio \
		--publish 3000:3000 \
		--rm \
		--tty \
		--volume "$(PWD):/app" \
		$(IMAGE_NAME):$(TAG_NAME)

release: build push
