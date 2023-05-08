#!/bin/zsh

# config
set -e

set -x

# script starts here

mkdir -p ../data_transfer
cp -fr ./data ../data_transfer/
mkdir -p ../data_transfer/.cache
cp -fr ~/.cache/huggingface ../data_transfer/.cache/
cp -fr ~/.cache/torch ../data_transfer/.cache/

cd .. && tar cvf data_transfer.tar data_transfer/ && gzip data_transfer.tar
