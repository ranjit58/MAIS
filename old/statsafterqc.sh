
cut -f 2,3 file_list.txt|while read a;
do
ARR=($a)
echo -ne "${ARR[1]}\t">>afterqcstats.txt
echo -e `grep -c ">" ${ARR[0]}/${ARR[1]}.fasta`>>afterqcstats.txt
#echo "$a"
done

