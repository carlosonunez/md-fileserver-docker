# md-fileserver for Docker

Builds Docker images for
[`md-fileserver`](https://github.com/commenthol/md-fileserver).

preview_markdown() {
  log_info "Visit http://localhost:6419 to view your stuff."
  docker run -i --rm -v $PWD:/data -p 6419:3080 thomsch98/markserv
}

## How to run

If you don't want to push up to Docker Hub:

```sh
./build.sh
```

If you do:

```sh
DOCKER_HUB_USERNAME=[your_username] \
DOCKER_HUB_PASSWORD=[your_password] \
./build.sh
```
