###########################################################################################
#                                                                                         #
#                      QIIME ANALYSIS SCRIPT FOR CLUSTER (non-parallel)                   #
#                                                                                         #
#                                       BY                                                #
#                                                                                         #
#                               RANJIT KUMAR (rkumar@uab.edu)                             #
#                                                                                         #
###########################################################################################

### usage   microbiome-workflow2.sh  ###


echo -e "#---------------------Align/filter/tree--------------------#\n">>script_adv.sh

echo -e "#Analysis Step 2\n">>script_adv.sh
echo 'align_seqs.py -i seqs.fna_rep_set.fasta -e 80 -v'>>script_adv.sh
echo 'filter_alignment.py -i pynast_aligned/seqs.fna_rep_set_aligned.fasta -v -o filtered_alignment'>>script_adv.sh
echo 'make_phylogeny.py -i filtered_alignment/seqs.fna_rep_set_aligned_pfiltered.fasta -v -o phylogeny.tre'>>script_adv.sh
echo -e "#'''''''''''''''''''''''''''''''''''''''''''''''''''#\n">>script_adv.sh


echo -e "#Analysis Step 3\n">>script_adv.sh

echo -e "#---------------------Alpha div---------------------#\n">>script_adv.sh

echo '# calculate the alpha div for given matrices : chao1,observed_species,PD_whole_tree,shannon,simpson'>>script_adv.sh
echo -e "alpha_diversity.py -i otu_table.biom -o alpha_div.txt -m chao1,observed_species,PD_whole_tree,shannon,simpson -t phylogeny.tre\n">>script_adv.sh

echo "# Create a parameters files and run alpha diversity through plots">>script_adv.sh
echo 'echo "alpha_diversity:metrics shannon,simpson,PD_whole_tree,chao1,observed_species" > alpha_params.txt'>>script_adv.sh
echo -e "alpha_rarefaction.py -i otu_table.biom -p alpha_params.txt -m mapping.txt -o alpha_rarefac -v -t phylogeny.tre\n">>script_adv.sh

echo -e "#'''''''''''''''''''''''''''''''''''''''''''''''''''#\n">>script_adv.sh


echo -e "#---------------------Beta div---------------------#\n">>script_adv.sh

echo '#create a rarified OTU table (usually select the sample size lowest among all the samples)'>>script_adv.sh
echo "#replace the -d number with your choice (otherwise default minimum called "EVEN" is calculated from otu_table.stats">>script_adv.sh
EVEN=$(cat otu_table.stats |head -13|tail -1|cut -d : -f 2|cut -d . -f 1| cut -d ' ' -f 2)
echo -e "single_rarefaction.py -i otu_table.biom -o otu_table_even.biom -d $EVEN\n">>script_adv.sh

echo '#Create a parameters files and run beta diversity through plots'>>script_adv.sh
echo 'echo "beta_diversity:metrics  bray_curtis,unweighted_unifrac,weighted_unifrac" > beta_params.txt'>>script_adv.sh
echo -e "beta_diversity_through_plots.py -i otu_table_even.biom -m mapping.txt -p beta_params.txt -o beta_div -v -t phylogeny.tre\n">>script_adv.sh

echo '# calculate beta div values for given three matrices : bray_curtis,unweighted_unifrac,weighted_unifrac'>>script_adv.sh
echo -e "beta_diversity.py -i otu_table_even.biom -m bray_curtis,unweighted_unifrac,weighted_unifrac -o beta_div_matrices -t phylogeny.tre\n">>script_adv.sh

echo -e "#'''''''''''''''''''''''''''''''''''''''''''''''''''#\n">>script_adv.sh



echo -e "#---------------------Jack Knife---------------------#\n">>script_adv.sh

echo "#for jacknife the value for -e should be 75% of $EVEN">>script_adv.sh
let EVEN_JACK=$EVEN*75/100
echo -e "#jackknifed_beta_diversity.py -i otu_table.txt -m mapping.txt -o beta_jacknife -e $EVEN_JACK -t phylogeny.tre\n">>script_adv.sh
echo -e "#''''''''''''''''''''''''''''''''''''''''''''''''''''#\n">>script_adv.sh


