###########################################################################################
#                                                                                         #
#                      QIIME ANALYSIS SCRIPT FOR CLUSTER (Parallel)                   #
#                                                                                         #
#                                       BY                                                #
#                                                                                         #
#                               RANJIT KUMAR (rkumar@uab.edu)                             #
#                                                                                         #
###########################################################################################

# Step 1 - read information file which includes the fastq file names and sample common name.
# Step 2 - unzip all the fastq files.
# Step 3 - run fastqc/prinseq on all the samples
# Step 4 - analyze quality data and do quality filtering as needed

# QIIME SPECIFIC STEPS

# Step 5 - convert all fastq files to fasta file. rename the samples. create one seqs.fna file from all the fasta files using our script.
# Step 6 - create mapping file, script file, clusterP.job file. clusterP. the script file has all the commands to be run on the clusterP.The clusterP.job has all the necessary information to submit the script on clusterP for processing.  


##### Global Variables (Make Changes here) #################

ANALYSIS_NAME="P-analysis"
RAM=4G
#specify time in hr as 1/2/8/10 etc
TIME=10
ANALYSIS_STEPS=123 # PICK 1/2/3 FOR OTU-ANALYSIS/ALIGN/DIVERSITY 123 OR 12 OR 23 OR 123 OR 1 OR 2 OR 3
RDP_CUTOFF=0.5    #USE 0.8 FOR 454 SEQUENCES
NUM_CPU=4
###########################################################



###########te a combined fasta file called as seqs.fna ###########

echo -e "\nCombining all the fasta files to create a single seqs.fna file for the QIIME analysis\n"
combinefasta_qiime.pl `ls *.fasta` seqs.fna
echo -e "\nCreated seqs.fna\n"

###########################################################################


### create the mapping file ##################
### take all fasta file with extension .fna in the current directory and creates the mapping file

echo -e "#SampleID\tLinkerPrimerSequence\tTreatment\tDOB\tDescription" >mapping.txt
echo '#Mapping file for the QIIME analysis (skipping the linker sequence)'>>mapping.txt
#find *.fasta|xargs -I {} echo -e "{}\t\tTreat\t`date +%Y%m%d`\tDesc" >>mapping.txt       
for file in $( ls *.fasta ); do echo -ne $file|sed -e 's/.fasta//g'>>mapping.txt; echo -e "\t\tTreat\t`date +%Y%m%d`\tDesc">>mapping.txt;done
#for $file $( ls *.fasta ); do echo -e $fasta|sed -e 's/.fasta//g'; echo -e "\t\tTreat\t`date +%Y%m%d`\tDesc";done


###########################################################################

########### create the clusterP.job file ##################

echo '#!/bin/bash'>clusterP.job
echo '#'>>clusterP.job
echo '# Define the shell used by your compute job'>>clusterP.job
echo '#'>>clusterP.job
echo '#$ -S /bin/bash'>>clusterP.job
echo '#'>>clusterP.job
echo '# Tell the clusterP to run in the current directory from where you submit the job'>>clusterP.job
echo '#'>>clusterP.job
echo '#$ -cwd'>>clusterP.job
echo '#'>>clusterP.job
echo '# Name your job to make it easier for you to track'>>clusterP.job
echo '# '>>clusterP.job
echo "#\$ -N $ANALYSIS_NAME">>clusterP.job
echo '#'>>clusterP.job
echo '# This will request 10 slots using the smp environment'>>clusterP.job
echo '# The smp environment forces all of the slots to be assigned to a single compute node'>>clusterP.job
echo "#\$ -pe smp $NUM_CPU">>clusterP.job
echo '#'>>clusterP.job
echo '# Request maximum runtime AND maximum amount of RAM needed per slot'>>clusterP.job
echo '#'>>clusterP.job
echo "#\$ -l h_rt=$TIME:00:00,s_rt=$TIME:00:00,vf=$RAM">>clusterP.job
echo '#'>>clusterP.job
echo '# Set your email address and request notification when you job is complete or if it fails'>>clusterP.job
echo '#'>>clusterP.job
echo '#$ -M rkumar@uab.edu'>>clusterP.job
echo '#$ -m eas'>>clusterP.job
echo '#'>>clusterP.job
echo '# Load the appropriate module files'>>clusterP.job
echo '#(no module is needed for this example, normally an appropriate module load command appears here)'>>clusterP.job
echo '#'>>clusterP.job
echo '# Tell the scheduler to use the environment from your current shell'>>clusterP.job
echo "#\$ -V">>clusterP.job
echo '#'>>clusterP.job
echo '# The ${NSLOTS} variable is automatically set by the scheduler to the number of slots requested'>>clusterP.job
echo '# This variable should be used if program have a parameter to specify the number of CPUs'>>clusterP.job
echo '# For e.g. denoise_wrapper.py -m mapping_corrected.txt -o denoiser_out1 -i sfftxt/allsff.txt -f split_out/seqs.fna -v --titanium -n ${NSLOTS}'>>clusterP.job
echo ''>>clusterP.job
echo 'sh script.sh'>>clusterP.job
############################################################


###########   create a script file    #####################

echo '### script file to be used to submit job on clusterP ###'>script.sh

if [ $ANALYSIS_STEPS -eq 1 ] || [ $ANALYSIS_STEPS -eq 12 ] || [ $ANALYSIS_STEPS -eq 123 ] ; then
echo "steps 1";

echo '#Analysis Step 1'>>script.sh
echo 'pick_otus.py -i seqs.fna -v'>>script.sh
echo 'pick_rep_set.py -i uclust_picked_otus/seqs_otus.txt -v -m most_abundant -l uclust_picked_otus/pick_rep_seq.log -f seqs.fna'>>script.sh
#echo "assign_taxonomy.py -i seqs.fna_rep_set.fasta -v -c $RDP_CUTOFF">>script.sh
echo -e "parallel_assign_taxonomy_rdp.py -i seqs.fna_rep_set.fasta -c $RDP_CUTOFF -o rdp22_assigned_taxonomy -O $NUM_CPU">>script.sh
echo 'make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -t rdp22_assigned_taxonomy/seqs.fna_rep_set_tax_assignments.txt -o otu_table.txt'>>script.sh
echo 'per_library_stats.py -i otu_table.txt > otu_table.stats'>>script.sh
echo 'summarize_taxa_through_plots.py -i otu_table.txt -m mapping.txt -v -o taxa_summary'>>script.sh

else
echo "Step 1 not found";
fi

if [ $ANALYSIS_STEPS -eq 123 ] || [ $ANALYSIS_STEPS -eq 23 ] || [ $ANALYSIS_STEPS -eq 2 ] ; then
echo "steps 2";


echo '#Analysis Step 2'>>script.sh
#echo 'align_seqs.py -i seqs.fna_rep_set.fasta -e 50 -v'>>script.sh
echo -e "parallel_align_seqs_pynast.py -i seqs.fna_rep_set.fasta -e 50 -o pynast_aligned -O $NUM_CPU">>script.sh
echo 'filter_alignment.py -i pynast_aligned/seqs.fna_rep_set_aligned.fasta -v -o filtered_alignment'>>script.sh
echo 'make_phylogeny.py -i filtered_alignment/seqs.fna_rep_set_aligned_pfiltered.fasta -v -o phylogeny.tre'>>script.sh

else
echo "Step 2 not found";
fi


if [ $ANALYSIS_STEPS -eq 123 ] || [ $ANALYSIS_STEPS -eq 23 ] || [ $ANALYSIS_STEPS -eq 3 ]; then
echo "steps 3";

echo '#Analysis Step 3'>>script.sh
echo -e "alpha_rarefaction.py -i otu_table.txt -m mapping.txt -o alpha_rarefac -v -t phylogeny.tre -a -O $NUM_CPU">>script.sh
echo -e "beta_diversity_through_plots.py -i otu_table.txt -m mapping.txt -o beta_div -v -t phylogeny.tre -a -O $NUM_CPU">>script.sh
#echo 'jackknifed_beta_diversity.py -i otu_table.txt -m mapping.txt -o beta_jacknife -e 150000 -a -t phylogeny.tre'>>script.sh


else
echo "Step 3 not found";
fi











