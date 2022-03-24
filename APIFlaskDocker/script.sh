#!/bin/bash

docker rm -f $(docker ps -a -q)

#sudo docker-compose down -f /home/ubuntu/APIFlaskDocker/docker-compose.yaml

# docker-compose rm -f /home/ubuntu/APIFlaskDocker/docker-compose.yaml

#sudo docker-compose up -f /home/ubuntu/APIFlaskDocker/docker-compose.yaml