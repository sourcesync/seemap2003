#!/bin/bash

echo "Initializing nano model speed test on '${MODEL}'..."

if [ -d "/home/mnist_png" ]; then
	echo "Found test images..."
else
	echo "Could not find test images..."
	exit 1
fi

if [ -f "/home/${MODEL}" ]; then
	echo "Found model to test..."
else
	echo "Could not find the model to test"
	exit 1
fi

python3 /home/nano_model_test_mnist.py "${MODEL}"
