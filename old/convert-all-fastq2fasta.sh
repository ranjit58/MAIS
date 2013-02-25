### Converting all the fastq files to the fasta fiels ###
echo -e "\nRunning the fastq to fasta conversion on all fastq files in directory\n"
for file in $( ls *.fastq) ; do fastq_to_fasta -r -i $file -o `echo $file|sed -e 's/fastq/fasta/g'` -Q33 ; done
echo -e "\nFastq to fasta conversion completed\n"
####

