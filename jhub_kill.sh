#!/bin/zsh

###############
# Config script

#set -x

set -e

####################
# Script starts here

#
# get jupyterhub instances and kill them
#

set +e
JUPHUB=$(ps -ef|grep -v grep|grep -v jupyterhub-single|grep jupyterhub)
set -e

if [ -z "$JUPHUB" ]
then
    echo "Could not find any jupyterhub instances"
else
    NUM=`echo $JUPHUB|wc -l`
    echo "Found $NUM instances..."
    PIDS=$(ps -ef|grep -v grep|grep -v jupyterhub-single|grep jupyterhub|awk '{ print $2 }')
    for p in `echo $PIDS`
    do
        echo "Trying to kill jupyterhub process at pid=$p"
        sudo kill $p
    done
fi

#
# get node proxy instances and kill them
#

set +e
NODE=$(ps -ef|grep -v grep|grep node)
set -e

if [ -z "$NODE" ]
then
    echo "Could not find any node instances"
else
    NUM=`echo $NODE|wc -l`
    echo "Found $NUM instances..."
    PIDS=$(ps -ef|grep -v grep|grep node|awk '{ print $2 }')
    for p in `echo $PIDS`
    do
        echo "Trying to kill jupyterhub process at pid=$p"
        #sudo kill $p
    done
fi

