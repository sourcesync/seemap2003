#!/bin/zsh

MODEL=$1

NANO=$2

if [ -f "${MODEL}" ]
then
    echo "Found your model "${MODEL}"
    echo
else
    echo "ERROR: Could not find your model ${MODEL}"
    exit 1
fi

if [ -z "${NANO}" ]
then
    NUM=$(awk -v min=5 -v max=10 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
    NANO="nano${NUM}"
    echo "Randomly choosing the nano called ${NANO}"
else
    echo "Using the nano called ${NANO}"
fi
echo

echo "Copying your model to the nano..."
scp "${MODEL}" "cuongwilliams@${NANO}:/home/cuongwilliams/"
echo

echo "Running model speed test on the nano..."
ssh "cuongwilliams@${NANO}" -t /home/cuongwilliams/nano_model_test.sh "${MODEL}"
