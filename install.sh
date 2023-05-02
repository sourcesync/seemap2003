#!/bin/zsh

#
# Script configuration
#

#set -x # uncomment this to execute this script verbosely
#set -e # uncomment this to terminate script on first error

#
# Script starts here
#

#
# Check Anaconda and conda env
#

# make sure we have conda
echo "Checking anaconda installed and available..."
GOT_CONDA=$(which conda)
if [ -z "$GOT_CONDA" ]; then
    echo "ERROR:  Pleasee install anaconda or make sure it's in PATH"
    exit 1
fi

# check for existing conda env
echo "Checking conda seemap2023 env..."
GOT_ENV=$(conda env list|grep seemap2023)
if [ -z "$GOT_ENV" ]; then
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
# Get Mac/MacOS info
#

# check OS version
GOT_MONTEREY=$(sw_vers|grep 12.6.3)

# check its an M1
GOT_M1=$(system_profiler SPHardwareDataType|grep M1)

if [ ! -z "$GOT_M1" ]; then
    python3 -m pip install -r requirements_mac_m1_2020.txt
elif [ ! -z "$GOT_MONTEREY" ]; then
    python3 -m pip install -r requirements_macos_monterey_12.6.3.txt
else
    echo "ERROR: Unsupported Mac/MacOS environment."
    exit 1
fi

echo "Done."


