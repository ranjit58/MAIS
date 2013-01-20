mkdir results_taxa
for list in $(cut -f 2 file_list.txt |sort|uniq);
do
mkdir results_taxa/$list
cp -r $list/taxa_summary results_taxa/$list/taxa_summary
echo -e "Succesfully copied taxa summary results for sample $list"
cp $list/otu_table.stats results_taxa/$list/otu_table.csv

done

tar -czf results_taxa.tar.gz results_taxa
echo -e "Final zipped version of all samples taxa information is created as \"results_taxa.tar.gz\""



