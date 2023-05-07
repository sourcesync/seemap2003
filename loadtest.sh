#!/bin/zsh

######################
#
# Script configuration
#
######################

# Workshop attendees are mapped to user accounts.
# Here we establish the per-machine maxium.  
# Don't change this unless you know what you are doing.
MAX_USERS=15

# the notebook to load test
NOTEBOOK="02_seemapld2023.ipynb"

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

sudo echo "Launching $MAX_USERS notebooks for load test..."

for i in {1..$MAX_USERS}
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

