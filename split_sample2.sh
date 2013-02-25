#-------------------------------------------------------------------------
# Name - split_sample2.sh
# Desc - The program reads a mapping file and organises the raw data into folders for each investigator
# Author - Ranjit Kumar (ranjit58@gmail.com)
# Source code - https://github.com/ranjit58/MAIS/
#-------------------------------------------------------------------------

# -----------Please edit the following filename and path information--------------------------
# PATH for RAW data
DIR_RAW='TEMP_ALL_FASTQ'
# Mapping file name
MAP='R9_mapping.txt'

DIR_MAPPED='R8_raw_data_mapped'

DIR_ANALYSIS='R9_analysis'
#---------------------------------------------------------------------------
mkdir $DIR_MAPPED
mkdir $DIR_ANALYSIS

if [ -e $MAP ]; then
echo -e "Mapping file ${MAP} found and is being used for sample grouping \n"

### creates all folders for different projects
cut -f 2 ${MAP} |sort|uniq |xargs -I {} mkdir ${DIR_MAPPED}/{}
cut -f 2 ${MAP} |sort|uniq |xargs -I {} mkdir ${DIR_ANALYSIS}/{}_analysis

while read line
do
    ARR=($line)
    cp ${DIR_RAW}/${ARR[0]} $DIR_ANALYSIS/${ARR[1]}_analysis/${ARR[2]}.fastq.gz
    mv ${DIR_RAW}/${ARR[0]} ${DIR_MAPPED}/${ARR[1]}/${ARR[2]}.fastq.gz
    #echo "moving files:   ${DIR_RAW}/${ARR[0]} ---> ${DIR_MAPPED}/${ARR[1]}/${ARR[2]}.fastq.gz"
done <${MAP}

echo -e "\n-------------------------------------------------------------\n"
echo -e "All files are renamed and moved to folder ${DIR_MAPPED} \n";
echo -e "Ideally the folder ${DIR_RAW} should be empty and can be deleted\n"
else 
echo "Mapping file \"${MAP}\" not found, Program Terminating..."

exit 0
fi
