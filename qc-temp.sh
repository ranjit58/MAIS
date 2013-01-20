
## unzip all the fastq files...
echo -e "Unzipping all the .gz files\n"
gunzip -v *.fastq.gz
echo -e "\nAll files gunzipped\n"


### running the fastqc runs on all the fastq files
echo -e "\nRunning the fastqc on all the fastq files\n"
fastqc *.fastq
echo -e "\nFastqc run completed\n"

echo -e "\nCreating fastqc results directory 'fastqc_beforeqc' before performing QC\n"
mkdir fastqc_beforeqc
mv *_fastqc fastqc_beforeqc/
mv *_fastqc.zip fastqc_beforeqc/
echo -r "\n Running stats on before_fastqc files\n"
cd fastqc_beforeqc
getqc-stats-65b.sh
cd ..
echo -e "\nfastqc before QC done\n"

### Running the QC on fastq files ###
echo -e "\nRunning the QC on all fastq files in the directory\n"
for file in $( ls *.fastq) ; 
do 
echo -e "\nworking on file $file \n\n trimming the reads\n"
fastx_trimmer -l 55 -i $file -o temp2.fastq -Q 33
rm $file
echo -e "\nDoing quality filtering\n"
fastq_quality_filter -q 30 -p 90 -i temp2.fastq -o $file -Q 33
rm temp2.fastq
done

### Running the fastqc again
echo -e "\nCreating fastqc results directory 'fastqc_afterc' after performing QC\n"
fastqc *.fastq
mkdir fastqc_afterqc
mv *_fastqc fastqc_afterqc/
mv *_fastqc.zip fastqc_afterqc/
echo -r "\n Running stats on after_fastqc files\n"
cd fastqc_afterqc
getqc-stats-55b.sh
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

