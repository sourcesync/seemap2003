#!/bin/zsh

# script config

set -e

set -x

# script starts here

USER=$1
USER_DIR=$2


# require sudo at this pint
sudo echo "Script requires sudo..."

# ssh key setup as needed
#sudo ls "$USER_DIR/.ssh"
if [ -f "$USER_DIR/.ssh/id_rsa.pub" ]
then
	echo "Found ssh pub key"
else
	echo "Did not find ssh pub key for $USER"
	sudo --user $USER ssh-keygen
fi

# push as authorized user to nanos
sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@192.168.2.12
sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@192.168.2.13
sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@192.168.2.14
sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@192.168.2.15
sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@192.168.2.16

sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@nano1
sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@nano2
sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@nano3
sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@nano4
sudo --user $USER --set-home ssh-copy-id -i $USER_DIR/.ssh/id_rsa.pub cuongwilliams@nano5

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
sudo cp ../data_transfer/*.ipynb survival_analysis.py test_model_speed_on_nano.sh $USER_DIR/
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
if [ -d $USER_DIR/.fastai/data/mnist_png ]
then
    echo "Found mnist_png dir - skipping the unpack, assuming it was already completed"
else
    sudo tar zxf ../data_transfer/mnist_png.tgz -C $USER_DIR/.fastai/data/
fi
sudo cp -f ../data_transfer/config.ini $USER_DIR/.fastai/

# jupyter config
sudo mkdir -p $USER_DIR/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/
sudo cp ../data_transfer/themes.jupyterlab-settings $USER_DIR/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/

# chmods and chowns
sudo chmod -R ugo+rw $USER_DIR/.fastai
sudo chown -R $USER $USER_DIR/.fastai
sudo chgrp -R staff $USER_DIR/.fastai
sudo chmod -R ugo+rw $USER_DIR/.cache
sudo chown -R $USER $USER_DIR/.cache
sudo chgrp -R staff $USER_DIR/.cache
sudo chown -R $USER $USER_DIR/.jupyter
sudo chgrp -R staff $USER_DIR/.jupyter

exit 0
