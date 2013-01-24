###########################################################################################
#                                                                                         #
#                      QIIME ANALYSIS SCRIPT FOR CLUSTER (non-parallel)                   #
#                                                                                         #
#                                       BY                                                #
#                                                                                         #
#                               RANJIT KUMAR (rkumar@uab.edu)                             #
#                                                                                         #
###########################################################################################

### usage   microbiome-workflow1.sh analysis_name ram time steps   ###

# Step 1 - read information file which includes the fastq file names and sample common name.
# Step 2 - unzip all the fastq files.
# Step 3 - run fastqc/prinseq on all the samples
# Step 4 - analyze quality data and do quality filtering as needed

# QIIME SPECIFIC STEPS

# Step 5 - convert all fastq files to fasta file. rename the samples. create one seqs.fna file from all the fasta files using our script.
# Step 6 - create mapping file, script file, cluster.job file. cluster. the script file has all the commands to be run on the cluster.The cluster.job has all the necessary information to submit the script on cluster for processing.  


##### Global Variables (Make Changes here) #################

ANALYSIS_NAME=$1
RAM=$2
#specify time in hr as 1/2/8/10 etc
TIME=$3
ANALYSIS_STEPS=$4 # PICK 1/2/3 FOR OTU-ANALYSIS/ALIGN/DIVERSITY 123 OR 12 OR 23 OR 123 OR 1 OR 2 OR 3
RDP_CUTOFF=0.5    #USE 0.8 FOR 454 SEQUENCES

###########################################################



###########te a combined fasta file called as seqs.fna ###########

echo -e "\nCombining all the fasta files to create a single seqs.fna file for the QIIME analysis\n"
combinefasta_qiime.pl `ls *.fasta` seqs.fna
echo -e "\nCreated seqs.fna\n"

###########################################################################


### create the mapping file ##################
### take all fasta file with extension .fna in the current directory and creates the mapping file

#echo -e "#SampleID\tLinkerPrimerSequence\tTreatment\tDOB\tDescription" >mapping.txt
#echo '#Mapping file for the QIIME analysis (skipping the linker sequence)'>>mapping.txt
#find *.fasta|xargs -I {} echo -e "{}\t\tTreat\t`date +%Y%m%d`\tDesc" >>mapping.txt       
#for file in $( ls *.fasta ); do echo -ne $file|sed -e 's/.fasta//g'>>mapping.txt; echo -e "\t\tTreat\t`date +%Y%m%d`\tDesc">>mapping.txt;done
#for $file $( ls *.fasta ); do echo -e $fasta|sed -e 's/.fasta//g'; echo -e "\t\tTreat\t`date +%Y%m%d`\tDesc";done


#echo -e "#SampleID\tCategory" >mapping.txt
echo -e "#SampleID" >mapping.txt
echo '#Mapping file for the QIIME analysis'>>mapping.txt
#find *.fasta|xargs -I {} echo -e "{}\t\tTreat\t`date +%Y%m%d`\tDesc" >>mapping.txt
#for file in $( ls *.fasta ); do echo -ne $file|sed -e 's/.fasta//g'>>mapping.txt; echo -e "\tGroup1">>mapping.txt;done
#for $file $( ls *.fasta ); do echo -e $fasta|sed -e 's/.fasta//g'; echo -e "\t\tTreat\t`date +%Y%m%d`\tDesc";done
for file in $( ls *.fasta ); do echo -e $file|sed -e 's/.fasta//g'>>mapping.txt; done
###########################################################################

########### create the cluster.job file ##################

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
echo "#\$ -l h_rt=$TIME:00:00,s_rt=$TIME:00:00,vf=${RAM}G">>cluster.job
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
echo 'sh script.sh'>>cluster.job
############################################################


###########  Create the script file    #####################

echo '### script file to be used to submit job on cluster ###' >script.sh

if [ $ANALYSIS_STEPS -eq 1 ] || [ $ANALYSIS_STEPS -eq 12 ] || [ $ANALYSIS_STEPS -eq 123 ] ; then
echo "steps 1";

echo '#Analysis Step 1'>>script.sh
echo 'pick_otus.py -i seqs.fna -s 1 -v'>>script.sh
echo 'pick_rep_set.py -i uclust_picked_otus/seqs_otus.txt -v -m most_abundant -l uclust_picked_otus/pick_rep_seq.log -f seqs.fna'>>script.sh
echo "#assign_taxonomy.py -i seqs.fna_rep_set.fasta -v -c $RDP_CUTOFF">>script.sh
echo '#make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -t rdp22_assigned_taxonomy/seqs.fna_rep_set_tax_assignments.txt -o otu_table_unsorted.biom'>>script.sh
echo "#---setting for blast searches---">>script.sh
echo "cp $QIIME../gg_12_10_otus/rep_set/97_otus.fasta .">>script.sh
echo "assign_taxonomy.py -i seqs.fna_rep_set.fasta -v -m blast -r 97_otus.fasta">>script.sh
echo "rm 97_otus.fasta">>script.sh
echo "#---setting ends for blast searches---">>script.sh
echo 'make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -t blast_assigned_taxonomy/seqs.fna_rep_set_tax_assignments.txt -o otu_table_unsorted.biom'>>script.sh
echo 'sort_otu_table.py -s SampleID -m mapping.txt -i otu_table_unsorted.biom -o otu_table.biom'>>script.sh
echo '#To enable the sorting based on external file, create a file sample_order.txt (containing all sample ids) and enable the next line code and disable the previous line code'>>script.sh
echo '#sort_otu_table.py -i otu_table_unsorted.biom -o otu_table.biom -l sample_order.txt'>>script.sh
echo 'per_library_stats.py -i otu_table.biom > otu_table.stats'>>script.sh
echo 'summarize_taxa_through_plots.py -i otu_table.biom -m mapping.txt -v -o taxa_summary'>>script.sh
echo '#make_otu_heatmap_html.py -i otu_table.biom -o OTU_Heatmap/'>>script.sh
echo '#make_otu_network.py -m mapping.txt -i otu_table.biom -o OTU_Network'>>script.sh
echo 'convert_biom.py -i otu_table.biom -o otu_table.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"'>>script.sh
echo '#convert_biom.py -i otu_table.biom -o otu_table2.txt -b --header_key taxonomy'>>script.sh
else
echo "Step 1 not found";
fi

if [ $ANALYSIS_STEPS -eq 123 ] || [ $ANALYSIS_STEPS -eq 23 ] || [ $ANALYSIS_STEPS -eq 2 ] ; then
echo "steps 2";

echo -e "#---------------------Align/filter/tree--------------------#\n">>script.sh

echo -e "#Analysis Step 2\n">>script.sh
echo 'align_seqs.py -i seqs.fna_rep_set.fasta -e 80 -v'>>script.sh
echo 'filter_alignment.py -i pynast_aligned/seqs.fna_rep_set_aligned.fasta -v -o filtered_alignment'>>script.sh
echo 'make_phylogeny.py -i filtered_alignment/seqs.fna_rep_set_aligned_pfiltered.fasta -v -o phylogeny.tre'>>script.sh
echo -e "#'''''''''''''''''''''''''''''''''''''''''''''''''''#\n">>script.sh

else
echo "Step 2 not found";
fi


if [ $ANALYSIS_STEPS -eq 123 ] || [ $ANALYSIS_STEPS -eq 23 ] || [ $ANALYSIS_STEPS -eq 3 ]; then
echo "steps 3";

echo -e "#Analysis Step 3\n">>script.sh

echo -e "#---------------------Alpha div---------------------#\n">>script.sh

echo '# calculate the alpha div for given matrices : chao1,observed_species,PD_whole_tree,shannon,simpson'>>script.sh
echo -e "alpha_diversity.py -i otu_table.biom -o alpha_div.txt -m chao1,observed_species,PD_whole_tree,shannon,simpson -t phylogeny.tre\n">>script.sh

echo "# Create a parameters files and run alpha diversity through plots">>script.sh
echo 'echo "alpha_diversity:metrics shannon,simpson,PD_whole_tree,chao1,observed_species" > alpha_params.txt'>>script.sh
echo -e "alpha_rarefaction.py -i otu_table.biom -p alpha_params.txt -m mapping.txt -o alpha_rarefac -v -t phylogeny.tre\n">>script.sh

echo -e "#'''''''''''''''''''''''''''''''''''''''''''''''''''#\n">>script.sh


echo -e "#---------------------Beta div---------------------#\n">>script.sh

echo '# calculate beta div values for given three matrices : bray_curtis,unweighted_unifrac,weighted_unifrac'>>script.sh
echo -e "beta_diversity.py -i otu_table_keep_even.biom -m bray_curtis,unweighted_unifrac,weighted_unifrac -o beta_div_matrices_keep -t phylogeny.tre\n">>script.sh

echo '#create a rarified OTU table (usually select the sample size lowest among all the samples)'>>script.sh
echo "#replace the -d number with your choice (otherwise default minimum called "EVEN" is calculated from otu_table.stats">>script.sh
EVEN=$(cat otu_table.stats |head -13|tail -1|cut -d : -f 2|cut -d . -f 1| cut -d ' ' -f 2)
echo -e "single_rarefaction.py -i otu_table.biom -o otu_table_even.biom -d $EVEN\n">>script.sh

echo '#Create a parameters files and run beta diversity through plots'>>script.sh
echo 'echo "beta_diversity:metrics  bray_curtis,unweighted_unifrac,weighted_unifrac" > beta_params.txt'>>script.sh
echo -e "beta_diversity_through_plots.py -i otu_table_even.biom -m mapping.txt -p beta_params.txt -o beta_div_even -v -t phylogeny.tre\n">>script.sh

echo -e "#'''''''''''''''''''''''''''''''''''''''''''''''''''#\n">>script.sh



echo -e "#---------------------Jack Knife---------------------#\n">>script.sh

echo "#for jacknife the value for -e should be 75% of $EVEN">>script.sh
let EVEN_JACK=$EVEN*75/100
echo -e "#jackknifed_beta_diversity.py -i otu_table.txt -m mapping.txt -o beta_jacknife -e $EVEN_JACK -t phylogeny.tre\n">>script.sh
echo -e "#''''''''''''''''''''''''''''''''''''''''''''''''''''#\n">>script.sh


else
echo "Step 3 not found";
fi











