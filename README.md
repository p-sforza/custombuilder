# custombuilder
To build the builder image:
docker build . --file Dockerfile --tag go-custom-docker-builder

To run builder for test or debug (note that docker.sock needed for docker ops within the builder):
docker run -it --privileged -v /run/docker.sock:/run/docker.sock go-custom-docker-builder bash
