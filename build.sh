#!/usr/bin/env bash
set -euo pipefail
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME?Please provide DOCKER_HUB_USERNAME}"
DOCKER_HUB_PASSWORD="${DOCKER_HUB_PASSWORD?Please provide DOCKER_HUB_PASSWORD}"

#TODO: Automate this.
versions() {
  cat <<-EOF
1.9.3
1.9.2
1.9.1
EOF
}

platforms() {
  cat <<-EOF
linux/amd64
linux/arm64
EOF
}

num_platforms() {
  wc -l <<< "$(platforms)"
}

tag() {
  local os="$1"
  local arch="${2:-""}"
  local version="${3:-""}"
  if test -z "$arch" && test -z "$version"
  then echo "$DOCKER_HUB_USERNAME/md-fileserver:${os}"
  elif test -n "$version" && test -n "$os" && test -n "$arch"
  then echo "$DOCKER_HUB_USERNAME/md-fileserver:${version}-${os}-${arch}"
  elif test -z "$version"
  then echo "$DOCKER_HUB_USERNAME/md-fileserver:${os}-${arch}"
  else echo "$DOCKER_HUB_USERNAME/md-fileserver:${version}-${os}"
  fi
}

>&2 echo "===> Logging into Docker Hub"
docker login --username "$DOCKER_HUB_USERNAME" --password "$DOCKER_HUB_PASSWORD" || exit 1
latest=0
latest_version=""
for version in $(versions | sort -r)
do
  amend=""
  for platform in $(platforms)
  do
    arch="$(basename "$platform")"
    tag="$(tag 'alpine' "$arch" "$version")"
    >&2 echo "===> Building $tag"
    export DOCKER_DEFAULT_PLATFORM="$platform"
    docker build --pull --platform "$platform" -t "$tag" \
      --build-arg VERSION="$version" . || \
      return 1
    docker push "$tag"
    if test "$latest" -lt "$(num_platforms)"
    then
      latest_version="$version"
      latest_tag="$(tag 'alpine' "$arch")"
      >&2 echo "===> Tagging $tag as latest: $latest_tag"
      docker tag "$tag" "$latest_tag"
      docker push "$latest_tag"
      latest=$((latest+1))
    fi
    amend="$amend --amend '$tag'"
  done
  unified_tag="$(tag 'alpine' "" "$version")"
  >&2 echo "===> Pushing unified image: $unified_tag"
  eval docker manifest create "$unified_tag" "$amend" &&
    docker manifest push "$unified_tag"
  if test "$version" == "$latest_version"
  then
    unified_tag="$(tag 'alpine' "" "")"
    >&2 echo "===> Pushing latest for OS: $unified_tag"
    eval docker manifest create "$unified_tag" "$amend" &&
      docker manifest push "$unified_tag"
  fi
done
