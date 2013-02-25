#echo -e "\n.....Starting the Report generation..old fashioned.....\n\n"
file=$1
mkdir ${file}_results;
cp -r taxa_summary ${file}_results/
cp -r beta_div ${file}_results/
cp otu_table.stats ${file}_results/otu_table.xls
zip -r ${file}_results.zip ${file}_results/
