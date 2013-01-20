
## unzip all the fastq files...
echo -e "Unzipping all the .gz files\n"
gunzip -v *.fastq.gz
echo -e "\nAll files gunzipped\n"


### running the fastqc runs on all the fastq files
echo -e "\nRunning the fastqc on all the fastq files\n"
fastqc --nogroup *.fastq
echo -e "\nFastqc run completed\n"

echo -e "\nCreating fastqc results directory 'fastqc_beforeqc' before performing QC\n"
mkdir fastqc_beforeqc
mv *_fastqc fastqc_beforeqc/
rm *_fastqc.zip
echo -e "\n Running stats on before_fastqc files\n"
cd fastqc_beforeqc
#getqc-stats-all.sh
#fastqcplot.sh
cd ..
echo -e "\nfastqc before QC done\n"

