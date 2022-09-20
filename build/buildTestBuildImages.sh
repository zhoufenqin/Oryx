#!/bin/bash
# --------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT license.
# --------------------------------------------------------------------------------------------

set -e

declare -r REPO_DIR=$( cd $( dirname "$0" ) && cd .. && pwd )

# Load all variables
source $REPO_DIR/build/__variables.sh
source $REPO_DIR/build/__functions.sh

buildImageDebianFlavor="$1"

echo
echo "Building build images for tests..."

echo "Building buster based github action image for tests..."
docker build \
    -t "$ORYXTESTS_BUILDIMAGE_REPO:github-actions-debian-buster" \
    --build-arg PARENT_IMAGE_BASE=github-actions-debian-buster \
    -f "$ORYXTESTS_GITHUB_ACTIONS_BUILDIMAGE_DOCKERFILE" \
    .

echo
echo
# check disk utilization
echo "check du"
du -hs /
echo "check df"
df -h
echo "Building bullseye based github action image for tests..."
docker build \
    -t "$ORYXTESTS_BUILDIMAGE_REPO:github-actions-debian-bullseye" \
    --build-arg PARENT_IMAGE_BASE=github-actions-debian-bullseye \
    -f "$ORYXTESTS_GITHUB_ACTIONS_BUILDIMAGE_DOCKERFILE" \
    .

echo
echo
# check disk utilization
echo "check du"
du -hs /
echo "check df"
df -h
echo "Building buster based lst version image for tests..."
docker build \
    -t "$ORYXTESTS_BUILDIMAGE_REPO:lts-versions-debian-buster" \
    --build-arg PARENT_IMAGE_BASE=lts-versions-debian-buster \
    -f "$ORYXTESTS_LTS_VERSIONS_BUILDIMAGE_DOCKERFILE" \
    .

echo
echo
# check disk utilization
echo "check du"
du -hs /
echo "check df"
df -h
echo "Building image that uses bullseye based github action as a base but doesn't have all required environment variables..."
docker build \
    -t "$ORYXTESTS_BUILDIMAGE_REPO:github-actions-debian-bullseye-base" \
    --build-arg PARENT_IMAGE_BASE=github-actions-debian-bullseye \
    -f "$ORYXTESTS_GITHUB_ACTIONS_ASBASE_BUILDIMAGE_DOCKERFILE" \
    .

echo
echo
# check disk utilization
echo "check du"
du -hs /
echo "check df"
df -h
echo "Building image that uses buster based github action as a base but doesn't have all required environment variables..."
docker build \
    -t "$ORYXTESTS_BUILDIMAGE_REPO:github-actions-debian-buster-base" \
    --build-arg PARENT_IMAGE_BASE=github-actions-debian-buster \
    -f "$ORYXTESTS_GITHUB_ACTIONS_ASBASE_BUILDIMAGE_DOCKERFILE" \
    .

echo
echo
# check disk utilization
echo "check du"
du -hs /
echo "check df"
df -h

echo "Building image that uses bullseye based github action as a base and has all required environment variables..."
docker build \
    -t "$ORYXTESTS_BUILDIMAGE_REPO:github-actions-debian-bullseye-base-withenv" \
    --build-arg PARENT_IMAGE_BASE=github-actions-debian-bullseye \
    --build-arg DEBIAN_FLAVOR=bullseye \
    -f "$ORYXTESTS_GITHUB_ACTIONS_ASBASE_WITHENV_BUILDIMAGE_DOCKERFILE" \
    .

echo
echo
# check disk utilization
echo "check du"
sudo du -hs / || true
du -hs /home/* || true
echo "check df"
df -h /home || true 
echo "Building image that uses buster based github action as a base and has all required environment variables..."
docker build \
    -t "$ORYXTESTS_BUILDIMAGE_REPO:github-actions-debian-buster-base-withenv" \
    --build-arg PARENT_IMAGE_BASE=github-actions-debian-buster \
    --build-arg DEBIAN_FLAVOR=buster \
    -f "$ORYXTESTS_GITHUB_ACTIONS_ASBASE_WITHENV_BUILDIMAGE_DOCKERFILE" \
    .

echo
echo
# check disk utilization
echo "check du"
du -hs /
echo "check df"
df -h
echo
dockerCleanupIfRequested
