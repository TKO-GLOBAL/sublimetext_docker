# Sublime Text Docker Image

## About
This is a simple docker container for Sublime Text to run in a clean
minimal Ubuntu environment.

## Build Image
To build the image, naviage to the directory the Dockerfile is in and run
``` Bash
$ DOCKER_BUILDKIT=1 docker build -t sublime:latest .
```

## Run Image
To use the image take the docker-compose.yaml file and adjust it to
suit your purpose. Then place the docker-compose.yaml file where
you want to run the image and run
``` Bash
$ docker compose run --rm shell
```
To start Sublime Text type `subl`. 

## Using Xauth
You can use Xauth to get a GUI out of the docker container.
Use 
``` Bash
$ xauth list
```
to see your authentication cookes and 
``` Bash
$ xauth add <cookie>
```
to add it to your .Xauthority file.