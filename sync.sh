#!/bin/zsh

# config

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

# quit on any script error
set -e

# echo each command
set -x

# script starts

# remove ipython/jupyter state from dev userr
sudo rm -fr ~/.ipython
sudo rm -fr ~/.jupyter

#
# add/verify/sync software/data to  workshop users
#
for i in {$START_USER..$END_USER}
do
    USER="workshop_$i"
    USER_DIR="/Users/$USER"
    echo "adding/verifying local user $USER_DIR"
    if [ -d "$USER_DIR" ]
    then
        echo "found $USER_DIR, perform user setup..."
        ./user_sync.sh $USER $USER_DIR
    fi
done
