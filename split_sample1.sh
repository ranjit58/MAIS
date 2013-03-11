#-------------------------------------------------------------------------
# Name - split_sample1.sh
# Desc - The program extracts all fastq.gz files in 1 folde and create a editable mapping file
# Author - Ranjit Kumar (ranjit58@gmail.com)
# Source code - https://github.com/ranjit58/MAIS/
#-------------------------------------------------------------------------

# -----------Please edit the following filename and path information--------------------------
# PATH for RAW data
DIR='R7_raw_data_dk'
# Mapping file name
MAP='R7_mapping.txt'

#--no need to edit--
TMP='TEMP_ALL_FASTQ'
TMP2='OVERVIEW'
#---------------------------------------------------------------------------

echo -e "\nProcessing please wait...\n"

# Step 1 : Create a temp file TEMP_ALL_FATSA and copy all fastq.gz files here.
mkdir TEMP_ALL_FASTQ
find $DIR/ -name "*.gz" -type f -print0|xargs -0 -I {} cp {} ${TMP}/

cp -r ${TMP} ${TMP2}

echo -e "Created a folder \"${TMP}\" with all fatsq.gz files...\n"
echo -e "Another similar folder \"${TMP2}\" with same data is created for overview analsysis...\n"

#*echo -e "\n.....Starting the Split files Script.....\n\n"
#*echo -e "Do you want to create a File List (for including sample information and splitting the data files (Press y/n)?"
#*read answer
#*if [ $answer = 'y' ] ; then 

# checking and removing preexisting mapping file
if [ -e $MAP ]
then
  mv $MAP $MAP.bak
  echo -e "A pre-exisiting mapping file \"${MAP}\" is found and is renamed as ${MAP}.bak\"\n"
fi

echo -e "Creating the mapping file \"${MAP}\".\n"

cd $TMP

for file in $( ls *.fastq.gz); do echo -ne "$file\t">>../${MAP}; echo -e "group1\t$file" | sed -e 's/_//g'>>../${MAP}; done

cd ..

echo -e "The mapping file \"${MAP}\" is succesfully created. A new name is assigned to each file after removing underscore and other characters. You should edit the names at your convenience, Otherwise use this file (not suggested).\n"

