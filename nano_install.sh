#!/bin/bash

# config

set -e

set -x

# script starts here

#
# docker containers
#

docker pull  nvcr.io/nvidia/l4t-pytorch:r32.7.1-pth1.10-py3
docker pull dustynv/l4t-pytorch:r35.1.0-pth1.13-py3

#
# camera stuff
#
sudo apt-get install libcanberra-gtk-module
