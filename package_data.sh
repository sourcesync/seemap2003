#!/bin/zsh

# config
set -e

set -x

# script starts here

#
# mac-mini data files
#

# Cleanup previous data copy
rm -fr ../data_transfer ../data_transfer.tar ../data_transfer.tar.gz
mkdir -p ../data_transfer

# Copy workspace data files
cp -fr ./data ../data_transfer/
# Copy torch cache (models)
mkdir -p ../data_transfer/.cache/torch/hub/checkpoints
cp -fr ~/.cache/torch/hub/checkpoints/mobilenetv3_small* ../data_transfer/.cache/torch/hub/checkpoints/
cp -fr ~/.cache/torch/hub/checkpoints/squeeze* ../data_transfer/.cache/torch/hub/checkpoints/
# Copy fastai images (tgz only and config.ini)
cp -fr ~/.fastai/archive/mnist_png.tgz ../data_transfer/
cp -fr ~/.fastai/config.ini ../data_transfer
# Copy jupyter configs
cp ~/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings ../data_transfer/

#
# nano data filee
#

# Cleanup previous data copy
rm -fr ../data_nano ../data_nano.tar ../data_nano.tar.gz
mkdir -p ../data_nano

# Copy data files
cp -fr ./data/hymenoptera_data_val_small ../data_nano

#
# make the tarballs
#

# Get timestamp for now
DT=$(date +%s)

# Create mac-mini tarball
CURDIR=$(pwd)
cd .. && tar cf "data_transfer_$DT.tar" data_transfer/ && gzip "data_transfer_$DT.tar" && cd $CURDIR

# Create nano tarball
CURDIR=$(pwd)
cd .. && tar cf "data_nano_$DT.tar" data_nano/ && gzip "data_nano_$DT.tar" && cd $CURDIR

echo "Created tarballs"
