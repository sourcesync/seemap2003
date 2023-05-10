#!/bin/zsh

# config

# this part determines the workshop users to iterate later on
HOST=`hostname`
if [[ "$HOST" == "ShellEVionsMini" ]]
then
    START_USER=26
    END_USER=50
elif [[ "$HOST" == "Shell-E-Visions-Mac-mini.local" ]]
then
    START_USER=26
    END_USER=50
else
    START_USER=1
    END_USER=25
fi

# quit on any script error
set -e

# echo each command
set -x

# script starts

# remove ipython/jupyter state from dev userr
sudo rm -fr ~/.ipython
sudo rm -fr ~/.jupyter

#
# add/verify/sync software/data to  workshop users
#
for i in {$START_USER..$END_USER}
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
        sudo cp -fr ../data_transfer/data/* $USER_DIR/data/
        sudo chmod -R ugo+rw $USER_DIR/data
        sudo cp -fr ../data_transfer/.cache/torch $USER_DIR/.cache/
        sudo chmod -R ugo+rw $USER_DIR/.cache
        sudo mkdir -p $USER_DIR/.fastai/archive
        sudo mkdir -p $USER_DIR/.fastai/data
        sudo cp -fr ../data_transfer/mnist_png.tgz $USER_DIR/.fastai/archive/ $USER_DIR/.fastai/data/
        sudo tar zxf ../data_transfer/mnist_png.tgz -C $USER_DIR/.fastai/data/
        sudo cp -f ../data_transfer/config.ini $USER_DIR/.fastai/
        sudo chmod -R ugo+rw $USER_DIR/.fastai
        sudo chown -R $USER /Users/workshop_1/.fastai
    fi
done
