
### Running the QC on fastq files ###
echo -e "\nRunning the QC on all fastq files in the directory\n"
for file in $( ls *.fastq) ; 
do 
echo -e "\nworking on file $file \n\n trimming the reads till first 90 base\n"
#fastx_trimmer -l 90 -i $file -o temp2.fastq -Q 33
fastx_trimmer -l 65 -i $file -o temp2.fastq -Q 33
rm $file
echo -e "\nDoing quality filtering round 1 (remove any read with base having Q<20\n"
fastq_quality_filter -q 20 -p 100 -i temp2.fastq -o temp3.fastq -Q 33
rm temp2.fastq

echo -e "\nDoing quality filtering round 2 (remove a read with 5% base having Q<30\n"
#fastq_quality_filter -q 30 -p 95 -i temp3.fastq -o $file -Q 33
fastq_quality_filter -q 30 -p 90 -i temp3.fastq -o $file -Q 33
rm temp3.fastq
done

### Running the fastqc again
echo -e "\nCreating fastqc results directory 'fastqc_afterc' after performing QC\n"
fastqc --nogroup *.fastq
mkdir fastqc_afterqc
mv *_fastqc fastqc_afterqc/
mv *_fastqc.zip fastqc_afterqc/
echo -r "\n Running stats on after_fastqc files\n"
cd fastqc_afterqc
#getqc-stats-all.sh
#fastqcplot.sh
#hist.sh
cd ..
echo -e "\nfastqc after QC done\n"


### Converting all the fastq files to the fasta fiels ###done
echo -e "\nRunning the fastq to fasta converison for all fastq in the directory\n"
for file in $( ls *.fastq) ;
do
echo -e "\nConverting fastq to fasta for file $file\n"
fastq_to_fasta -r -i $file -o `echo $file|sed -e 's/fastq/fasta/g'` -Q33 ; 
rm $file
done

echo -e "\nALL QC done\n"
####

