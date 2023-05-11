#!/bin/bash

PRNT="/home/cuongwilliams/Projects/SEEMAP2023"
CURDIR=$(pwd)

#sudo docker run -it --rm -v $CURDIR:$CURDIR -v $PRNT:$PRNT --runtime nvidia --network host nvcr.io/nvidia/l4t-pytorch:r32.7.1-pth1.10-py3
#sudo docker run -it --rm -v $CURDIR:$CURDIR -v $PRNT:$PRNT --runtime nvidia --network host dustynv/l4t-pytorch:r35.1.0-pth1.13-py3
sudo docker run -it --rm -v $CURDIR:$CURDIR -v $PRNT:$PRNT --runtime nvidia --network host t_f
