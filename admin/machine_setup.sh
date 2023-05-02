#!/bin/zsh

set -x
set -e

USER_CMD="$(pwd)/user_setup.sh"
echo $USER_CMD

SCREEN_CMD="sudo -u seemap2023_1 $USERCMD; exec zsh"
echo $SCREEN_CMD

screen -dmS seemap2023_1 sudo -u seemap2023_1 sh -c "$USER_CMD" 

#sudo -u seemap2023_1 "$USER_CMD"
