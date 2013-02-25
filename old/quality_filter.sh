
#for all files with extension .fastq -> do these quality filtering

echo -e "\nDo you want to apply quality filtering on all .fastq files (Press y/n)?\n"
read answer
if [ $answer = 'y' ] ; then

#---code start -----
echo -e "\nStarting the quality filtering steps...\n"
mkdir filter_data
for file in $( ls *.fastq) ; 
do

fastx_trimmer -l 51 -i $file -o filter_data/temp -Q 33
fastq_quality_filter -q 30 -p 90 -i filter_data/temp -o filter_data/$file -Q 33
rm filter_data/temp

done

echo -e "\nQuality filtering done...\n"

else

echo -e "Not applying any quality filteriung steps..\n"

fi

echo -e "\nDo you want to apply fastq2fatsa conversion on all .fastq files in folder filter_data(Press y/n)?\n"
read answer
if [ $answer = 'y' ] ; then

### Converting all the fastq files to the fasta fiels ###
echo -e "\nRunning the fastq to fasta conversion on all fastq files in directory\n"
cd filter_data
for file in $( ls *.fastq) ; do fastq_to_fasta -r -i $file -o `echo $file|sed -e 's/fastq/fasta/g'` -Q33 ; done
rm *.fastq
echo -e "\nFastq2fatsa conversion done...\n"

####
else
echo -e "Not applying fastq2fasta conversion..\nExits...\n"
fi

