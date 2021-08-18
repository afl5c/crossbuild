

run:
	podman run --rm -v ~/workspace:/workspace:z -it afl5c/crossbuild bash

build:
	podman build -t afl5c/crossbuild .

push:
	podman login docker.io
	podman push afl5c/crossbuild:latest
