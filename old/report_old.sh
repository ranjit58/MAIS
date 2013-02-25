#echo -e "\n.....Starting the Report generation..old fashioned.....\n\n"
#echo -e "This program will read all folders in the current directories (assuming each directory has results for specific investigators) and creates a tar file of specific results in repective folders (Press y/n)?"
#read answer
#if [ $answer = 'y' ] ; then
#echo -e "\nReading directory list.....\n";
#for file in $( ls *.fastq.gz); do echo -ne "$file\t">>file_list.txt; echo -e "group1\t$file" | sed -e 's/_//g'>>file_list.txt; done
#for file in $( ls -d */); do echo -e "Working on directory $file ...";
file=$1/
mkdir ${file}${file////}_results;
cp -r ${file}taxa_summary ${file}${file////}_results/taxa_summary
cp -r ${file}beta_div ${file}${file////}_results/beta_div
cp ${file}otu_table.stats ${file}${file////}_results/otu_table.csv
tar -czf ${file}${file////}_results.tar.gz ${file}${file////}_results/
#rm -r ${file}${file////}_results/
#done
#fi
