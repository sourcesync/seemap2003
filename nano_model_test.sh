#!/bin/bash

CURDIR=$(pwd)

sudo docker run -it --rm -v $CURDIR:/home -v $PRNT:$PRNT --runtime nvidia --network host t_f
