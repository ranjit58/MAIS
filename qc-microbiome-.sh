
## find all compressed fastq files and create a Sample_names file [this is to remove all underscore and dashes, rename it if required]
echo -e "\n.....Starting the QC Script.....\n\n"
echo -e "Do you want to create a Sample_names file (Press y/n)?"
read answer
if [ $answer = 'y' ] ; then 
echo -e "\nCreting the Sample_names file. You should edit the names at your convenience, Otherwise unedited file will be processed.\n"
rm Sample_names
for file in $( ls *.fastq.gz); do echo -ne "$file\t">>Sample_names; echo $file| sed -e 's/_//g'>>Sample_names; done
for file in $( ls *.fastq); do echo -ne "$file\t">>Sample_names; echo $file| sed -e 's/_//g'>>Sample_names; done

echo -e "Following Sample_names file is created..."
echo -e "\n----------------------------------------------------\n"
cat Sample_names
echo -e "\n----------------------------------------------------\n"

#ls *.fastq.gz|xargs -I {} echo -e "{}\t{}"| sed -e 's/_//g'>Sample_names
else
echo -e "\nNot creating the Sample_names file and moving to next step...\n"
fi


echo "Do you want to terminate the program to edit Sample_ names (Press y/n)?"
read answer
if [ $answer = 'y' ] ; then
echo -e "\nProgram Terminated"
exit 0
echo "Program Continuing.... to next step...\n"
fi


### Read the Sample_names file and rename the fastq.gz files.
if [ -e Sample_names ]; then
echo -e "Sample_names file found, so renaming the fastq files\n"
echo -e "The following file names in column 1 are going to be replaced by column 2"
echo -e "\n-------------------------------------------------------------\n"

while read line
do
    echo -e "$line"
    mv $line
done <Sample_names

echo -e "\n-------------------------------------------------------------\n"
echo -e "File renaming done\n";
else 
echo "File 'Sample_names' not found, Program Terminating..."
exit 0
fi

## unzip all the fastq files...
echo -e "Unzipping the .gz files\n"
gunzip -v *.fastq.gz
echo -e "\nAll files gunzipped\n"


### running the fastqc runs on all the fastq files
#echo -e "\nRunning the fastqc on all the fastq files\n"
#fastqc *.fastq
#echo -e "\nFastqc run completed\n"


### Converting all the fastq files to the fasta fiels ###
echo -e "\nRunning the fastq to fasta conversion on all fastq files in directory\n"
for file in $( ls *.fastq) ; do fastq_to_fasta -r -i $file -o `echo $file|sed -e 's/fastq/fasta/g'` -Q33 ; done
echo -e "\nFastq to fasta conversion completed\n"
####


echo -e "\nPlease analyze the quality files and do the necessary quality filtering. Replace the qualit
y filtered file with the same name as original file\n"
echo -e "Thanks done.....\n\n"

