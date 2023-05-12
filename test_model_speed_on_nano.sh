#!/bin/zsh

MODEL=$1

NANO=$2

if [ -f "${MODEL}" ]
then
    echo "Found your model ${MODEL}"
    echo
else
    echo "ERROR: Could not find your model ${MODEL}"
    exit 1
fi

# choose a nano as needed
if [ -z "${NANO}" ]
then
    NUM=$(awk -v min=1 -v max=5 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
    NANO="nano${NUM}"
    echo "Randomly choosing the nano called ${NANO}"
    echo
else
    echo "Using the nano called ${NANO}"
    echo
fi

echo "Copying your model to nano..."
scp "${MODEL}" "cuongwilliams@${NANO}:/home/cuongwilliams/"
echo

echo "Launch model speed test program..."
ssh "cuongwilliams@${NANO}" -t /home/cuongwilliams/nano_model_test.sh "${MODEL}"
echo
