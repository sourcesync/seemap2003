#!/bin/zsh

######################
#
# Script configuration
#
######################

# Workshop attendees are mapped to user accounts.
# Here we establish the per-machine maxium.  
# Don't change this unless you know what you are doing.
MAX_USERS=10

# Uncomment this to execute this script verbosely
#set -x 

# Uncomment this to terminate this script on first error
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
conda install -c conda-forge jupyterhub jupyter_core jupyter_server jupyterlab

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
    python3 -m pip install -r requirements_mac_m1_2020.txt
elif [ ! -z "$GOT_MONTEREY" ]
then
    echo "installing python requirements..."
    python3 -m pip install -r requirements_macos_monterey_12.6.3.txt
else
    echo "ERROR: Unsupported Mac/MacOS environment."
    exit 1
fi

#
# add/verify workshop users
#
for i in {1..$MAX_USERS}
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
            # copy notebook and change its permissions
            sudo cp *.ipynb *.py $USER_DIR/
            sudo chmod ugo+r $USER_DIR/*.ipynb $USER_DIR/*.py
            sudo chmod ugo-w $USER_DIR/*.ipynb $USER_DIR/*.py
            sudo cp -fr images $USER_DIR/
        fi    
        echo $USER
    fi
done

#
# Finalize
#
echo "Done."


