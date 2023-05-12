#!/bin/bash

MODEL=$1

echo "Copying your model to nano..."
scp "${MODEL}" cuongwilliams@192.168.1.9:/home/cuongwilliams/

echo "Running model speed test on nano..."
ssh cuongwilliams@192.168.1.9 -t /home/cuongwilliams/nano_model_test.sh "${MODEL}"