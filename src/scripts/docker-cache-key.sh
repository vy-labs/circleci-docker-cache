# DOCKERFILE=docker/Dockerfile
# VERSION=$(cat .python-version)
# BASE_IMAGE_NAMES=$(grep "^FROM" $DOCKERFILE | cut -d' ' -f2 | uniq)
# FINAL_BASE_IMAGE_NAMES=$(eval echo "$BASE_IMAGE_NAMES")
# cp $DOCKERFILE docker-layer-caching-key.txt
# for ref in $FINAL_BASE_IMAGE_NAMES; do
#     if grep -q ':' \<<< "$ref"; then
#     REPOSITORY=$(cut -d':' -f1 \<<< "$ref")
#     TAG=$(cut -d':' -f2 \<<< "$ref")
#     else
#     REPOSITORY=$ref
#     TAG="latest"
#     fi
#     # If there is no slash in the repo name, it is an official image,
#     # we will need to prepend library/ to it
#     if ! grep -q '/' \<<< "$REPOSITORY"; then
#     REPOSITORY="library/$REPOSITORY"
#     fi
#     acceptM="application/vnd.docker.distribution.manifest.v2+json"
#     acceptML="application/vnd.docker.distribution.manifest.list.v2+json"
#     token=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${REPOSITORY}:pull" \
#         | jq -r '.token')
#     IMAGE_DIGEST=$(curl -H "Accept: ${acceptM}" \
#     -H "Accept: ${acceptML}" \
#     -H "Authorization: Bearer $token" \
#     -I -s "https://registry-1.docker.io/v2/${REPOSITORY}/manifests/${TAG}" | \
#     grep -i ^etag: | cut -d: -f2-)
#     echo $IMAGE_DIGEST >> docker-layer-caching-key.txt
# done
# echo $BUILD_EXCLUDE_ENVS >> docker-layer-caching-key.txt