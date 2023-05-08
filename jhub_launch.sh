#!/bin/zsh

###############
# Config script

set -x
 
set -e

####################
# Script starts here

echo "Launch Jupyterhub..."
source ~/.zshrc
conda activate seemap2023

#
# Check for jupyter hub already running
#

set +e
JUPHUB=$(ps -ef|grep -v grep|grep -v jupyterhub-single|grep jupyterhub)
set -e

if [ -z "$JUPHUB" ]
then
    echo "Could not find any jupyterhub instances"
else
    NUM=`echo $JUPHUB|wc -l`
    echo "Found $NUM jupyterhub instances..."
    exit 1
fi

#
# get node proxy instances and kill them
#

set +e
NODE=$(ps -ef|grep -v grep|grep node|grep http-proxy)
set -e

if [ -z "$NODE" ]
then
    echo "Could not find any node instances"
else
    NUM=`echo $NODE|wc -l`
    echo "Found $NUM node instances..."
    exit 1
fi

echo "Cleaning up any previous jupyterhub state..."
sudo rm -f jupyterhub.sqlite jupyterhub_cookie_secret

echo "Launch jupyterhub..."

HOST=`hostname`
if [[ "$HOST" == "ShellEVionsMini" ]]
then
	sudo jupyterhub --config=jupyter_config_ShellEVionsMini.py
elif [[ "$HOST" == "Shell-E-Visions-Mac-mini.local" ]]
	sudo jupyterhub --config=jupyter_config_ShellEVionsMini.py
else
	sudo jupyterhub --config=jupyterhub_config.py
fi

echo "Done."
