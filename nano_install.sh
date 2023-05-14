#!/bin/bash

# config

set -e

set -x

# script starts here

#
# docker containers
#

set +e

#docker pull  nvcr.io/nvidia/l4t-pytorch:r32.7.1-pth1.10-py3
docker pull dustynv/l4t-pytorch:r35.1.0-pth1.13-py3

#
# camera stuff
#
sudo apt-get install libcanberra-gtk-module


#
# custom docker build
#

./dockerbuild.sh

set -e

#
# copy model testing files
#

# look for nano blob
if [ -d "../data_nano" ]; then
	echo "Found ../data_nano"
else
	echo "Could not find ../data_nano"
	exit 1
fi

# unpack mnist_png files
if [ -d "$HOME/mnist_png" ]; then
    	echo "Found mnist_png dir - skipping the unpack, assuming it was already completed"
else
	echo "Did not find ~/mnist_png"
    	sudo tar zxf ../data_nano/mnist_png.tgz -C $HOME
fi

cp -f nano_model_test_mnist.py ~/
cp -f nano_start.sh ~/
cp -f nano_model_test.sh ~/
cp -f ../data_nano/test_fastai_mnist.pt ~/

echo "Done."
