#!/bin/zsh

echo "Launch Jupyterhub..."
source ~/.zshrc
conda activate seemap2023
sudo rm jupyterhub.sqlite jupyterhub_cookie_secret
sudo jupyterhub --config=jupyterhub_config.py
