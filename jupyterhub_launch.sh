#!/bin/zsh


# Check if it's already running
JUPYTER_RUNNING=$(pgrep jupyterhub)
if [ ! -z "$JUPYTER_RUNNING" ]
then
    echo "Jupyterhub is already running..."
else
    echo "Launch Jupyterhub..."
    source ~/.zshrc
    conda activate seemap2023
    sudo rm jupyterhub.sqlite jupyterhub_cookie_secret
    sudo jupyterhub --config=jupyterhub_config.py
fi
