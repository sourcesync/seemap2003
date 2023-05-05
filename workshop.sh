#!/bin/zsh

# Check if it's already running
JUPYTER_RUNNING=$(pgrep jupyterhub)
if [ ! -z "$JUPYTER_RUNNING" ]
then
    echo "Jupyterhub is already running..."
else
    echo "Launch behind screen..."
    LAUNCH_CMD=$(pwd)/jupyterhub_launch.sh
    screen -d -m bash -c "/Users/gwilliams/Projects/SEEMAP2023/seemap2023/jupyterhub_launch.sh"
    echo "Make sure to connect to the screen to finish the launch..."
    screen -list
fi
