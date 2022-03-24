#!/bin/bash

sudo apt update

sudo apt install python3-pip -y

sudo apt install docker -y

sudo apt install docker-compose -y

sudo usermod -aG docker $USER

sudo chown $USER /var/run/docker.sock

