#!/bin/zsh

# config
set -e

set -x

# script starts here

# Cleanup previous data copy
rm -fr ../data_transfer ../data_transfer.tar ../data_transfer.tar.gz
mkdir -p ../data_transfer

# Copy data files
cp -fr ./data ../data_transfer/
mkdir -p ../data_transfer/.cache
#cp -fr ~/.cache/huggingface ../data_transfer/.cache/
cp -fr ~/.cache/torch ../data_transfer/.cache/

# Get timestamp for now
DT=$(date +%s)

# Create tarball
cd .. && tar cvf "data_transfer_$DT.tar" data_transfer/ && gzip "data_transfer_$DT.tar"

echo "Created tarball data_transfer_$DT.tar."
