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

# Copy data files
cp -fr ./data ../data_transfer/
mkdir -p ../data_transfer/.cache
cp -fr ~/.cache/torch ../data_transfer/.cache/

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
cd .. && tar cvf "data_transfer_$DT.tar" data_transfer/ && gzip "data_transfer_$DT.tar" && cd $CURDIR

# Create nano tarball
CURDIR=$(pwd)
cd .. && tar cvf "data_nano_$DT.tar" data_nano/ && gzip "data_nano_$DT.tar" && cd $CURDIR

echo "Created tarballs"
