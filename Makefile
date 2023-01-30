# if no arguments, build main executable to ./bin/example
all: bin/example

# default to building for your own machine
PLATFORM=local

# don't target existing ./bin/example
.PHONY: bin/example

# build executable with Dockerfile to ./bin/. s/podman/docker if you wish
bin/example:
	@podman build . \
	--target bin \
	--output bin/ \
	--platform local
