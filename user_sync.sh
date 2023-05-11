#!/bin/zsh

# script config

set -e

set -x

# script starts here

USER=$1
USER_DIR=$2

# clean up user dir
set +e
sudo rm -f $USER_DIR/*.ipynb
sudo rm -f $USER_DIR/*.py
sudo rm -fr $USER_DIR/__pycache__
sudo rm -fr $USER_DIR/.ipython
sudo rm -fr $USER_DIR/.jupyter
sudo rm -fr $USER_DIR/.ipynb_checkpoints
set -e

# copy workshop files and change permissions as needed
sudo cp ../data_transfer/*.ipynb survival_analysis.py $USER_DIR/
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
sudo chown -R $USER $USER_DIR/.fastai
sudo chgrp -R staff $USER_DIR/.fastai
sudo chmod -R ugo+rw $USER_DIR/.cache
sudo chown -R $USER $USER_DIR/.cache
sudo chgrp -R staff $USER_DIR/.cache

exit 0
