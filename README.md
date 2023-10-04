# md-fileserver for Docker

Builds Docker images for
[`md-fileserver`](https://github.com/commenthol/md-fileserver).

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
