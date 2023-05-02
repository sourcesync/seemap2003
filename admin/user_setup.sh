#!/bin/zsh

conda info --envs
whoami
cd ~
pwd
source ~/.zshrc
conda activate jh
which jupyterhub
jupyterhub --port=8001
sleep 10
echo "done"

