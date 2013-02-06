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

echo '#Analysis Step 1'>>script.sh
echo '#------------------------- Pick OTUs ----------------------------------------------'>>script.sh
echo '#pick_otus.py -i seqs.fna -s 0.97 -v'>>script.sh
echo 'pick_otus.py -i seqs.fna -s 1 -v'>>script.sh

echo '#------------------------- Pick representative of OTUs ----------------------------'>>script.sh
echo 'pick_rep_set.py -i uclust_picked_otus/seqs_otus.txt -v -m most_abundant -l uclust_picked_otus/pick_rep_seq.log -f seqs.fna'>>script.sh


echo '#------------------------- Create temp OTU table (without taxonomy) ----------------------------'>>script.sh
echo 'make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -o otu_table.biom'>>script.sh


echo '#------------------------- Filter OTUs ----------------------------'>>script.sh
echo '# To turn off OTU filterring just comment all the commands in this block'>>script.sh
echo '# Filter OTUs which has total abundunce of less than 10 reads. Then fix the fasta file pick_rep_set.py'>>script.sh
echo '#After creating filtered OTU and fasta file, we just replace them with the original'>>script.sh
echo 'filter_otus_from_otu_table.py -i otu_table.biom -o otu_table_fil_n10.biom -n 10'>>script.sh
echo 'filter_fasta.py -f seqs.fna_rep_set.fasta -o seqs.fna_rep_set_fil_n10.fasta -b otu_table_fil_n10.biom'>>script.sh
echo 'mv seqs.fna_rep_set.fasta seqs.fna_rep_set_org.fasta'>>script.sh
echo 'mv seqs.fna_rep_set_fil_n10.fasta seqs.fna_rep_set.fasta'>>script.sh
echo 'rm otu_table.biom otu_table_fil_n10.biom'>>script.sh

echo '#------------------------- Assign taxonomy using RDP and create OTU table ---------'>>script.sh
echo "#assign_taxonomy.py -i seqs.fna_rep_set.fasta -v -c $RDP_CUTOFF">>script.sh
echo '#make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -t rdp22_assigned_taxonomy/seqs.fna_rep_set_tax_assignments.txt -o otu_table_unsorted.biom'>>script.sh

echo '#-------------------------Assign taxonomy using BLAST and create OTU table --------'>>script.sh
echo "#---setting for blast searches---">>script.sh
echo "cp $QIIME../gg_12_10_otus/rep_set/97_otus.fasta .">>script.sh
echo "assign_taxonomy.py -i seqs.fna_rep_set.fasta -v -m blast -r 97_otus.fasta">>script.sh
echo "rm 97_otus.fasta">>script.sh
echo "#---setting ends for blast searches---">>script.sh
echo 'make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -v -t blast_assigned_taxonomy/seqs.fna_rep_set_tax_assignments.txt -o otu_table_org.biom'>>script.sh
echo 'filter_otus_from_otu_table.py -i otu_table_org.biom -o otu_table_fil_n10_unsorted.biom -n 10'>>script.sh

echo '#------------------------- Sort OTU table -----------------------------------------'>>script.sh
echo '#Sort ysing sample ID'>>script.sh
echo 'sort_otu_table.py -s SampleID -m mapping.txt -i otu_table_fil_n10_unsorted.biom -o otu_table.biom'>>script.sh
echo '#To enable the sorting based on external file, create a file sample_order.txt (containing all sample ids) and enable the next line code and disable the previous line code'>>script.sh
echo '#sort_otu_table.py -i otu_table_fil_n10_unsorted.biom -o otu_table.biom -l sample_order.txt'>>script.sh



echo '#------------------------- OTU table statistics -----------------------------------'>>script.sh
echo 'per_library_stats.py -i otu_table.biom > otu_table.stats'>>script.sh


echo '#------------------------- Summarizing taxa information ---------------------------'>>script.sh
echo '#summarize_taxa_through_plots.py -i otu_table.biom -m mapping.txt -v -o taxa_summary'>>script.sh
echo 'summarize_taxa.py -i otu_table.biom -o taxa_summary'>>script.sh
echo 'plot_taxa_summary.py -i taxa_summary/otu_table_L2.txt,taxa_summary/otu_table_L3.txt,taxa_summary/otu_table_L4.txt,taxa_summary/otu_table_L5.txt,taxa_summary/otu_table_L6.txt -o taxa_summary/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus -d 300 -c bar,area'>>script.sh

echo '#------------------------- Summarizing taxa information (trimmed version)-----------'>>script.sh
echo '#This will trim any OTU which has overall abundance less than 0.1%'>>script.sh
echo 'summarize_taxa.py -i otu_table.biom -o taxa_summary_trim -u 0.001'>>script.sh
echo 'plot_taxa_summary.py -i taxa_summary_trim/otu_table_L2.txt,taxa_summary_trim/otu_table_L3.txt,taxa_summary_trim/otu_table_L4.txt,taxa_summary_trim/otu_table_L5.txt,taxa_summary_trim/otu_table_L6.txt -o taxa_summary_trim/taxa_summary_plots/ -l Phylum,Class,Order,Family,Genus -d 300 -c bar,area'>>script.sh

echo '#------------------------- Create OTU Heatmap ------------------------------'>>script.sh
echo '#make_otu_heatmap_html.py -i otu_table.biom -o OTU_Heatmap/'>>script.sh

echo '#------------------------- Create OTU Network ------------------------------'>>script.sh
echo '#make_otu_network.py -m mapping.txt -i otu_table.biom -o OTU_Network'>>script.sh

echo '#------------------------- Convert BIOM file to TXT file--------------------'>>script.sh
echo 'convert_biom.py -i otu_table.biom -o otu_table.txt -b --header_key taxonomy --output_metadata_id "ConsensusLineage"'>>script.sh
echo '#convert_biom.py -i otu_table.biom -o otu_table2.txt -b --header_key taxonomy'>>script.sh

