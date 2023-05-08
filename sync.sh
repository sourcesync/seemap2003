#!/bin/zsh

# config

MAX_USERS=25

set -e

set -x

# script starts


#
# add/verify/sync software/data to  workshop users
#
for i in {1..$MAX_USERS}
do
    USER="workshop_$i"
    USER_DIR="/Users/$USER"
    echo "adding/verifying local user $USER_DIR"
    if [ -d "$USER_DIR" ]
    then
        echo "found $USER_DIR, perform user setup..."
        # cleanup first
        set +e
        sudo rm -f $USER_DIR/*.ipynb
        sudo rm -f $USER_DIR/*.py
        sudo rm -fr $USER_DIR/__pycache__
        sudo rm -fr $USER_DIR/.ipython
        sudo rm -fr $USER_DIR/.jupyter
        sudo rm -fr $USER_DIR/.ipynb_checkpoints
        set -e
        # copy workshop files and change permissions as needed
        sudo cp *.ipynb survival_analysis.py $USER_DIR/
        sudo chmod ugo+r $USER_DIR/*.ipynb $USER_DIR/*.py
        sudo chmod ugo-w $USER_DIR/*.ipynb $USER_DIR/*.py
        sudo cp -fr images $USER_DIR/
        sudo cp -fr ../data_transfer/* $USER_DIR/data/
        sudo chmod -R ugo+rw $USER_DIR/data
        sudo cp -fr ../data_transfer/.cache/huggingface $USER_DIR/.cache/
        sudo cp -fr ../data_transfer/.cache/torch $USER_DIR/.cache/
        sudo chmod -R ugo+rw $USER_DIR/.cache
    fi
done
