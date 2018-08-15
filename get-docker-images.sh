#!/bin/bash -eu
# Copyright London Stock Exchange Group All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#
# This script pulls docker images from the Dockerhub hyperledger repositories

# set the default Docker namespace and tag
DOCKER_NS=hyperledger
VERSION=1.2.0
THIRDPARTY_IMAGE_VERSION=0.4.10 # Kafka & Zookeeper

# set of Hyperledger Fabric images
FABRIC_IMAGES=(fabric-peer fabric-orderer fabric-ccenv fabric-tools fabric-ca)

for image in ${FABRIC_IMAGES[@]}; do
  echo "Pulling ${DOCKER_NS}/$image:${VERSION} ..."
  docker pull ${DOCKER_NS}/$image:${VERSION}
  docker tag ${DOCKER_NS}/$image:${VERSION} ${DOCKER_NS}/$image:latest
done

# TP Hyperledger Fabric images
TP_FABRIC_IMAGES=(fabric-kafka fabric-zookeeper)
for image in ${TP_FABRIC_IMAGES[@]}; do
  echo "Pulling ${DOCKER_NS}/$image:${THIRDPARTY_IMAGE_VERSION} ..."
  docker pull ${DOCKER_NS}/$image:${THIRDPARTY_IMAGE_VERSION}
  docker tag ${DOCKER_NS}/$image:${THIRDPARTY_IMAGE_VERSION} ${DOCKER_NS}/$image:latest
done

docker images ${DOCKER_NS}/*