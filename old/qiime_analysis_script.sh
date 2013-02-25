pick_otus.py -i seqs.fna
pick_rep_set.py -i uclust_picked_otus/seqs_otus.txt -m most_abundant -l uclust_picked_otus/pick_rep_seq.log -f seqs.fna
assign_taxonomy.py -i seqs.fna_rep_set.fasta -c 0.8
make_otu_table.py -i uclust_picked_otus/seqs_otus.txt -t rdp22_assigned_taxonomy/seqs.fna_rep_set_tax_assignments.txt -o otu_table.txt
per_library_stats.py -i otu_table.txt > otu_table.stats
summarize_taxa_through_plots.py -i otu_table.txt -m mapping.txt -o taxa_summary
