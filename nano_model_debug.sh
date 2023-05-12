#!/bin/bash

MODEL=$1

CURDIR=$(pwd)

sudo docker run -it --rm -v $CURDIR:/home --env MODEL="${MODEL}" --runtime nvidia --network host --entrypoint /bin/bash t_f
