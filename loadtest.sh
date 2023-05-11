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
    END_USER=10
fi

# the notebook to load test
#NOTEBOOK="04_seemapld2023.ipynb"
#NOTEBOOK="02_FastAI_MNIST.ipynb"
NOTEBOOK="04_seemapld2023_fastai_mnist.ipynb"

# Uncomment this to execute this script verbosely
set -x 

# Uncomment this to terminate this script on first error
set -e 

####################
#
# Script starts here
#
####################

# Check/load conda env
source ~/.zshrc
conda activate seemap2023

# Check test notebook exists
if [ -f "$NOTEBOOK" ]
then
    echo "Found notebook $NOTEBOOK"
else
    echo "ERROR: Could not find $NOTEBOOK"
fi

# Check loadtest notebooks aren't already running
set +e
JUP=$(ps -ef|grep -v grep|grep jupyter-nbconvert)
set -e
if [ -z "$JUP" ]
then
    echo "No load test in progress."
else
    NUM=`echo $JUP|wc -l`
    echo "ERROR: Found $NUM load test notebook instances running."
    exit 1
fi

# Created a dated results dir
DT=$(date +%s)
DTDIR="/tmp/$DT"
mkdir -p "$DTDIR"
echo "results dir $DTDIR"
LOGF="$DTDIR/log.txt"
echo "log file at $LOGF"

sudo echo "Launching ${START_USER}...${END_USER} notebooks for load test..."

for i in {$START_USER..$END_USER}
do
    USER="workshop_$i"
    echo "$USER"
    NBIN="/Users/workshop_$i/$NOTEBOOK"
    DT=$(date +%s)
    echo "$DT"
    NBOUT="${DTDIR}/${USER}_${DT}_$NOTEBOOK.html"
    echo "Launching notebook for workshop_$i"
    sudo time jupyter nbconvert --debug --to html --execute $NBIN --output $NBOUT >>$LOGF 2>&1 &
done

tail -f "$LOGF"

echo "Done."

