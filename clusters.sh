
##### Global Variables (Make Changes here) #################

ANALYSIS_NAME=$1
RAM=$2
#specify time in hr as 1/2/8/10 etc
TIME=$3
ANALYSIS_STEPS=$4 # PICK 1/2/3 FOR OTU-ANALYSIS/ALIGN/DIVERSITY 123 OR 12 OR 23 OR 123 OR 1 OR 2 OR 3

###########################################################

echo '#!/bin/bash'>cluster.job
echo '#'>>cluster.job
echo '# Define the shell used by your compute job'>>cluster.job
echo '#'>>cluster.job
echo '#$ -S /bin/bash'>>cluster.job
echo '#'>>cluster.job
echo '# Tell the cluster to run in the current directory from where you submit the job'>>cluster.job
echo '#'>>cluster.job
echo '#$ -cwd'>>cluster.job
echo '#'>>cluster.job
echo '# Name your job to make it easier for you to track'>>cluster.job
echo '# '>>cluster.job
echo "#\$ -N $ANALYSIS_NAME">>cluster.job
echo '#'>>cluster.job
echo '# Tell the scheduler only need 10 minutes'>>cluster.job
echo '#'>>cluster.job
echo "#\$ -l h_rt=$TIME:00:00,s_rt=$TIME:00:00,vf=$RAM">>cluster.job
echo '#'>>cluster.job
echo '# Set your email address and request notification when you job is complete or if it fails'>>cluster.job
echo '#'>>cluster.job
echo '#$ -M rkumar@uab.edu'>>cluster.job
echo '#$ -m eas'>>cluster.job
echo '#'>>cluster.job
echo '#'>>cluster.job
echo '# Load the appropriate module files'>>cluster.job
echo '#'>>cluster.job
echo '# (no module is needed for this example, normally an appropriate module load command appears here)'>>cluster.job
echo '#'>>cluster.job
echo '# Tell the scheduler to use the environment from your current shell'>>cluster.job
echo ''>>cluster.job
############################################################








