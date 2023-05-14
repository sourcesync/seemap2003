#!/bin/bash

echo "$(hostname): Initializing nano model speed test on '${MODEL}'..."
echo

if [ -d "/home/mnist_png" ]; then
        echo "$(hostname): Found test images..."
        echo
else
        echo "Could not find test images..."
        exit 1
fi

if [ -f "/home/${MODEL}" ]; then
        echo $(hostname): "Found model to test..."
        echo
else
        echo "Could not find the model to test"
        exit 1
fi

python3 -W ignore::UserWarning /home/nano_model_test_mnist.py "${MODEL}"

