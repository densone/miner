#!/bin/bash

set -euo pipefail

# MINER_REGISTRY_NAME
# IMAGE_ARCH
# IMAGE_FORMAT
# all come from pipeline.yml

MINER_REGISTRY_NAME="$REGISTRY_HOST/team-helium/$REGISTRY_NAME"
DOCKER_NAME="$(basename $(pwd))-${IMAGE_ARCH}_${BUILDKITE_TAG}"
DOCKERFILE_NAME=".buildkite/scripts/Dockerfile-val-${IMAGE_ARCH}"

VERSION=$(git describe --abbrev=0 | sed -e 's,validator,,')

docker login -u="team-helium+buildkite" -p="${QUAY_BUILDKITE_PASSWORD}" ${REGISTRY_HOST}
docker build --build-arg version=$VERSION -t helium:$DOCKER_NAME -f "${DOCKERFILE_NAME}" .
docker tag helium:$DOCKER_NAME "$MINER_REGISTRY_NAME:$DOCKER_NAME"
docker push "$MINER_REGISTRY_NAME:$DOCKER_NAME"
