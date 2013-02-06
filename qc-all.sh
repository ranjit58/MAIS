qc1.sh
cd fastqc_beforeqc/
getqc-stats-all.sh
fastqcplot.sh
cd ..

qc2.sh
cd fastqc_afterqc/
getqc-stats-all.sh
fastqcplot.sh
cd ..
