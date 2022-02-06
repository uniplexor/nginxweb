#!/bin/bash

set -x

# build a minimal image
newcontainer=$(buildah from alpine)
alpinemnt=$(buildah mount $newcontainer)

# install the packages
buildah run $newcontainer /bin/sh -c 'apk update && apk add nginx'
buildah run $newcontainer /bin/sh -c 'rm -rf $alpinemnt/var/cache/apk/*'

# set some config info
buildah config --label name=nginx-alpine $newcontainer
buildah config --cmd "nginx -g 'daemon off;'" $newcontainer

# commit the image
buildah unmount $newcontainer
buildah commit $newcontainer luis13byte/nginx-alpine
