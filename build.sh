#!/bin/bash
echo "build.sh start!"
set -e
set -o pipefail

if [ ! -e "${DOCKER_SOCKET}" ]; then
  echo "Docker socket missing at ${DOCKER_SOCKET}"
  exit 1
fi

if [ -n "${OUTPUT_IMAGE}" ]; then
  TAG="${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}"
fi

# Create the package
echo "git repo cloning start!"
git clone $SOURCE_URI /tmp/src

echo "go build start!"
cd /tmp/src
go build -o go-run

# Create the docker file for the final image
echo "Dockerfile prepare!"
cat > Dockerfile <<- EOF
FROM openshift/origin-base 
COPY go-run $HOME/go-run
CMD  $HOME/go-run
EOF

echo "Docker build start!"
docker build --rm -t "${TAG}" .
export DOCKER_USR=serviceaccount
export DOCKER_PWD=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
docker login -u $DOCKER_USR -p $DOCKER_PWD 172.30.1.1:5000
docker push "${TAG}"
