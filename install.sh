#!/bin/zsh

######################
#
# Script configuration
#
######################

# this part determines the workshop users to iterate later on
HOST=`hostname`
if [[ "$HOST" == "ShellEVionsMini" ]]
then
    START_USER=26
    END_USER=50
elif [[ "$HOST" == "Shell-E-Visions-Mac-mini.local" ]]
then
    START_USER=26
    END_USER=50
else
    START_USER=1
    END_USER=25
fi

# echo script commands
set -x 

# terminate script on any error
set -e 

####################
#
# Script starts here
#
####################

# TODO: Make sure we aren't sudo here


#
# Check/install Anaconda and conda env
#

# make sure we have conda
echo "Checking anaconda installed and available..."
GOT_CONDA=$(which conda)
if [ -z "$GOT_CONDA" ]
then
    echo "ERROR:  Pleasee install anaconda or make sure it's in PATH"
    exit 1
# else
#   TODO: Download Anaconda and install as neeeded
fi

# check for existing conda env
echo "Checking conda seemap2023 env..."
set +e
GOT_ENV=$(conda env list|grep seemap2023)
set -e
if [ -z "$GOT_ENV" ]
then
    echo "Installing conda seemap2023 env..."
    conda create -n seemap2023 python=3.8
    source ~/.zshrc
else
    echo "Found conda seemap20233 env..."
    source ~/.zshrc
fi

echo "Activating seemap2023 env..."
conda activate seemap2023

#
# Install Jupyterhub
#
echo "Installing/checking jupyterhub..."

# Note these are separate to avoid long resolver (?)
conda install -q -c conda-forge jupyterhub
conda install -q -c conda-forge jupyter_core
conda install -q -c conda-forge jupyter_server
conda install -q -c conda-forge jupyterlab

#
# Get Mac/MacOS info and install remainder of requirements
#

# check if MacOS version is Monterey
set +e
GOT_MONTEREY=$(sw_vers|grep 12.6.3)
set -e

# check if its an M1
set +e
GOT_M1=$(system_profiler SPHardwareDataType|grep M1)
set -e

echo "Installing/verifying python packages..."
if [ ! -z "$GOT_M1" ]
then
    echo "installing python requirements..."
    python3 -m pip install --quiet -r requirements_mac_m1_2020.txt
elif [ ! -z "$GOT_MONTEREY" ]
then
    echo "installing python requirements..."
    python3 -m pip install --quiet -r requirements_macos_monterey_12.6.3.txt
else
    echo "ERROR: Unsupported Mac/MacOS environment."
    exit 1
fi

# henceforth we need sudo
sudo echo "Verifying and syncing workshop users (${START_USER} to ${END_USER})"

#
# add/verify/sync software/data to  workshop users
#
for i in {$START_USER..$END_USER}
do
    # TODO: Right now we are just verifying users exist
    # TODO: but eventually this will also create those
    # TODO: users.
    if [[ ! -z "$GOT_MONTEREY" ||  ! -z "$GOT_M1" ]]
    then
        USER="workshop_$i"
        USER_DIR="/Users/$USER"
        echo "adding/verifying local user $USER_DIR"
        if [ -d "$USER_DIR" ]
        then
            echo "found $USER_DIR, perform user setup..."
            ./user_sync.sh $USER $USER_DIR
        fi    
        echo $USER
    fi
done

#
# Finalize
#
echo "Done."


