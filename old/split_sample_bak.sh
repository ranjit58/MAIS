### This script will create a list of all .gz files in the current folder and give an option to edit that list to include sample information. Then the script creates an individual folders for each sample and moves all .gz files in respective folder. It will also create a mapping file in each folder.
## find all compressed fastq files and create a Sample_names file [this is to remove all underscore and dashes, rename it if required]
echo -e "\n.....Starting the Split files Script.....\n\n"
echo -e "Do you want to create a File List (for including sample information and splitting the data files (Press y/n)?"
read answer
if [ $answer = 'y' ] ; then 
echo -e "\nCreating the "file_list.txt" sample names file. You should edit the names at your convenience, Otherwise unedited file will be processed.\n"
rm -f file_list.txt
for file in $( ls *.fastq.gz); do echo -ne "$file\t">>file_list.txt; echo -e "group1\t$file" | sed -e 's/_//g'>>file_list.txt; done

echo -e "Following Sample_names file is created..."
echo -e "\n----------------------------------------------------\n"
cat file_list.txt
echo -e "\n----------------------------------------------------\n"

#ls *.fastq.gz|xargs -I {} echo -e "{}\t{}"| sed -e 's/_//g'>Sample_names
else
echo -e "\nNot creating the file "file_list.txt" sample names file and moving to next step...\n"
fi


echo "Do you want to terminate the program to edit file_list.txt (Press y/n)?"
read answer
if [ $answer = 'y' ] ; then
echo -e "\nProgram Terminated"
exit 0
echo "Program Continuing.... to next step...\n"
fi


### Read the Sample_names file and rename the fastq.gz files ###
if [ -e file_list.txt ]; then
echo -e "Sample_names file found, so renaming the fastq files\n"
echo -e "The following file names in column 1 are going to be replaced by column 2"
echo -e "\n-------------------------------------------------------------\n"

### creates all folders
cut -f 2 file_list.txt |sort|uniq |xargs -I {} mkdir {}

while read line
do
    ARR=($line)
    mv ${ARR[0]} ${ARR[1]}/${ARR[2]}.fastq.gz
    echo "moving files:      ${ARR[0]} ${ARR[1]}/${ARR[2]}.fastq.gz"
done <file_list.txt

echo -e "\n-------------------------------------------------------------\n"
echo -e "File renaming done\n";
else 
echo "File 'file_list.txt' not found, Program Terminating..."
exit 0
fi

## unzip all the fastq files...
#echo -e "Unzipping the .gz files\n"
#gunzip -v *.fastq.gz
#echo -e "\nAll files gunzipped\n"


### running the fastqc runs on all the fastq files
#echo -e "\nRunning the fastqc on all the fastq files\n"
#fastqc *.fastq
#echo -e "\nFastqc run completed\n"


### Converting all the fastq files to the fasta fiels ###
#echo -e "\nRunning the fastq to fasta conversion on all fastq files in directory\n"
#for file in $( ls *.fastq) ; do fastq_to_fasta -r -i $file -o `echo $file|sed -e 's/fastq/fasta/g'` -Q33 ; done
#echo -e "\nFastq to fasta conversion completed\n"
####


#echo -e "\nPlease analyze the quality files and do the necessary quality filtering. Replace the qualit
#y filtered file with the same name as original file\n"
#echo -e "Thanks done.....\n\n"

