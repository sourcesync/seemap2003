#!/bin/zsh

MODEL=$1

NANO=$2

if [ -f "${MODEL}" ]
then
    echo "Found your model ${MODEL}"
    echo
    # lets copy to a unique name
    UNIQUE="${USER}.pt"
    cp "${MODEL}" "${HOME}/${UNIQUE}"
    echo "mini: Copied model to unique name ${UNIQUE}"
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
    echo "mini: Randomly choosing the nano called ${NANO}"
    echo
else
    echo "mini: Using the nano called ${NANO}"
    echo
fi

echo "mini: Copying your model to ${NANO}..."
scp "${UNIQUE}" "cuongwilliams@${NANO}:/home/cuongwilliams/"
echo

echo "mini: Launching model speed test program on ${NANO}..."
ssh "cuongwilliams@${NANO}" -t /home/cuongwilliams/nano_model_test.sh "${UNIQUE}"
echo

