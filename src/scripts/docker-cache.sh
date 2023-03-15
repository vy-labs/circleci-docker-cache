#!/bin/bash
# DOCKERFILE="${DOCKERFILE}"

CACHE_LOCATION=/tmp/docker-layer-caching-key.txt
VERSION=$(cat ."${LANGUAGE}"-version 2>/dev/null)
BASE_IMAGE_NAMES=$(grep "^FROM" "$DOCKERFILE" | cut -d' ' -f2 | uniq)
FINAL_BASE_IMAGE_NAMES=$(eval echo "$BASE_IMAGE_NAMES")

cp "$DOCKERFILE" $CACHE_LOCATION
for ref in $FINAL_BASE_IMAGE_NAMES; do
  IMAGE_DIGEST=$(skopeo inspect --format '{{ .Digest }}' docker://"$ref")
  echo "$IMAGE_DIGEST" >> $CACHE_LOCATION
done
echo "$VERSION" >> $CACHE_LOCATION
echo "$BUILD_EXCLUDE_ENVS" >> $CACHE_LOCATION
