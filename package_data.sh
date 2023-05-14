#!/bin/zsh

# config
set -e

set -x

# script starts here

#
# package mac-mini data files
#

# Cleanup previous state
rm -fr ../data_transfer ../data_transfer.tar ../data_transfer.tar.gz
mkdir -p ../data_transfer

# Copy notebook first clearing output cells
jupyter nbconvert --clear-output --to notebook --output=../data_transfer/02_seemapld2023_jupyter_notebooks.ipynb 02_seemapld2023_jupyter_notebooks.ipynb
jupyter nbconvert --clear-output --to notebook --output=../data_transfer/03_seemapld2023_survival.ipynb 03_seemapld2023_survival.ipynb
jupyter nbconvert --clear-output --to notebook --output=../data_transfer/05_seemapld2023_fastai_mnist.ipynb 05_seemapld2023_fastai_mnist.ipynb
#cp 02_seemapld2023_survival.ipynb ../data_transfer/
#cp 04_seemapld2023_fastai_mnist.ipynb ../data_transfer/

# Copy workspace data files
cp -fr ./data ../data_transfer/
cp -fr ./images ../data_transfer/

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
# package nano data filee
#

# Cleanup previous data copy
rm -fr ../data_nano ../data_nano.tar ../data_nano.tar.gz
mkdir -p ../data_nano

# Copy data files
#cp -fr ./data/hymenoptera_data_val_small ../data_nano/
cp -fr ~/.fastai/archive/mnist_png.tgz ../data_nano/
cp test_fastai_mnist.pt  ../data_nano

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
