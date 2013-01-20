echo "Creating directory report_files for storing HTML report specific files in the current directory ...";
mkdir report_files
#cp -r fastqc_afterqc/ report/fastqc_afterqc
#cp -r fastqc_beforeqc/ report/fastqc_beforeqc
#cp -r taxa_summary/ report/taxa_summary
#cp -r alpha_rarefac/ report/alpha_rarefac
#cp -r beta_div/ report/beta_div
#cp alpha_div_matrices report/alpha_div_matrices.txt
#cp otu_table.stats report/otu_table.stats 
cp ~/workdir/my-scripts/cheaha/arrow.png report_files/
cp ~/workdir/my-scripts/cheaha/open-in-new-window.gif report_files/oinw.gif
cp ~/workdir/my-scripts/cheaha/q.jpg report_files/

#----------Start:Initial Sequencing Overview-------------------#

cat <<EOF >report_files/initial_overview.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Initial Overview</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Samples_and_sequencing_overview"></a> &nbsp;
Initial Sequence Overview</h2>
      </td>
    </tr>
  </tbody>
</table>
<span style="color: black;">
This
section describes the&nbsp;samples and their sequencing statistics
as they come from the sequencing machines. <br>
<br>
The table below&nbsp;shows the number of
samples,&nbsp;sequences per
sample and&nbsp;their initial quality statistics.<br><br>
</span>

EOF

if [ -e fastqc_beforeqc/qcstats.txt ]; then
echo -e '<table style="text-align: left; width: 900px; height: 61px;margin-left: 60px;" border="1" cellpadding="2" cellspacing="1">'>>report_files/initial_overview.html
echo -e "<thead><tr><th>Count</th><th>Sample Name</th><th>Sequences </th><th>Read Length </th> <th>GC Content </th><th> FastQC Plots</th></tr> </thead><tbody>">>report_files/initial_overview.html
COUNT=1;

while read line
do
	arrIN=(${line/// })
fastqclink=${arrIN[0]/.fastq/}
echo "<tr><td>${COUNT}</td><td>${arrIN[0]}</td><td>${arrIN[1]}</td><td>${arrIN[2]}</td><td>${arrIN[3]}</td><td><a href=\"../fastqc_beforeqc/${fastqclink}_fastqc/fastqc_report.html\" target=\"_blank\">FASTQC</a></tr>">>report_files/initial_overview.html
COUNT=$(($COUNT + 1 ));
done <fastqc_beforeqc/qcstats.txt

echo "</tbody></table>">>report_files/initial_overview.html
fi
cat <<EOF >>report_files/initial_overview.html

<br>
<br>
<br>
<br>
The individual quality plots from all samples are combined below to
provide a overview merged quality plot. The plot shows the mean Qscore vs base position for all samples.<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="../fastqc_beforeqc/FASTQCplot.png"><br>
<br>
Dowload the raw dataset (tab delimited format, right click -> save link as)<br>
<ol>
  <li>
	<a href="../fastqc_beforeqc/qcstats.txt" target="_blank">Sample stats file</a>
  </li>
  <li>
	<a href="../fastqc_beforeqc/qcplot.txt" target="_blank">Per base sequence quality file</a>
</li>
</ol>
<br>
</div>

EOF

#----------Ends:Initial Overview------------------------------#


#----------Start:Quality Control------------------------------#

cat <<EOF >report_files/quality_control.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Quality Control</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Quality_Control"></a> &nbsp;
Quality Control</h2>
      </td>
    </tr>
  </tbody>
</table>
<span style="color: black;">This section describes the QC(quality control) procedure applied to the raw dataset. After applying all the QC steps the sequence quality plots are regenerated. </span><br
 style="color: black;">
<br style="color: black;">
<span style="color: black;"><b>QC Method : </b></span>
</br>
<div style="text-align: justify;">For most
samples&nbsp;the length of sequence reads is 101 bases. Usually the
quality of base drops toward the&nbsp;end of a read. The average
base quality i.e. Q&gt;30 is considered good. Q30 means that the
probability of a base being wrong is 0.001. Similarly, Q40 means that
the probability of a base being wrong is 0.0001 and Q20 means that the
probability of a base being wrong is 0.01.<br>
</div>
<br>
For the QC, three sequencial steps are applied for all samples<br>
<ol>
  <li>The last 11 bases are removed from all the reads. So the
read length becomes 90bases.</li>
  <li>Any read which has a base quality Q&lt;20 is discarded.</li>
  <li>Any read which has more that 5% bases with Q&lt;30 is
discarded.</li>
</ol>
<br>
<span style="color: black;">
After Applying the QC steps, the table below shows the number of samples, sequences per
sample and their quality statistics.
</span><br><br>
EOF

if [ -e fastqc_afterqc/qcstats.txt ]; then
echo -e '<table style="text-align: left; width: 900px; height: 61px;margin-left: 60px;" border="1" cellpadding="2" cellspacing="1">'>>report_files/quality_control.html
echo -e "<thead><tr><th>Count</th><th>Sample Name</th><th>Sequences </th><th>Read Length </th> <th>GC Content </th><th> FastQC Plots</th></tr> </thead><tbody>">>report_files/quality_control.html
COUNT=1;
while read line
do
        arrIN=(${line/// })
fastqclink=${arrIN[0]/.fastq/}
echo "<tr><td>${COUNT}</td><td>${arrIN[0]}</td><td>${arrIN[1]}</td><td>${arrIN[2]}</td><td>${arrIN[3]}</td><td><a href=\"../fastqc_afterqc/${fastqclink}_fastqc/fastqc_report.html\" target=\"_blank\">FASTQC</a></tr>">>report_files/quality_control.html
COUNT=$(($COUNT + 1 ));
done <fastqc_afterqc/qcstats.txt
echo "</tbody></table>">>report_files/quality_control.html
fi
cat <<EOF >>report_files/quality_control.html

<br>
<br>
<br>

The individual quality plots from all samples are combined below to
provide a overview merged quality plot. The plot shows the mean Qscore vs base position for all samples.<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="../fastqc_afterqc/FASTQCplot.png"><br>
<br>
Dowload the raw dataset after applying QC measures (tab delimited format, right click -> save link as)<br>
<ol>
  <li>
        <a href="../fastqc_afterqc/qcstats.txt" target="_blank">Sample stats file</a>
  </li>
  <li>
        <a href="../fastqc_afterqc/qcplot.txt" target="_blank">Per base sequence quality file</a>
</li>
</ol>
<br>

EOF
#----------End:Quality Control------------------------------#

#----------Start:Sample selected and mapping file ------------------------------#

cat <<EOF >report_files/sample_mapping.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Sample seleted for analysis and mapping information"></a> &nbsp; Sample seleted for analysis and mapping information</h2>
      </td>
    </tr>
  </tbody>
</table>
<span style="color: black;">This section describes the samples seletcted (after the QC step) for the analysis. It also includes the number of OTUs (unique sequences identified across all the samples. It also includes the mapping file (samples attributes).</span><br
 style="color: black;"></br>
<br style="color: black;">
<span style="color: black;"><b>Samples Selected and their stats (with OTU numbers)</b></span>
</br></br>
EOF


echo -e "----------------------------------------------------------------------------------</br>">>report_files/sample_mapping.html
if [ -e otu_table.stats ]; then
while read line
do
echo -e "$line<br>">>report_files/sample_mapping.html
done <otu_table.stats
fi
echo -e "----------------------------------------------------------------------------------</br>">>report_files/sample_mapping.html

cat <<EOF >>report_files/sample_mapping.html
</br></br><br style="color: black;">
<span style="color: black;"><b>Mapping file</b></span>
</br></br>

EOF

echo -e "----------------------------------------------------------------------------------</br>">>report_files/sample_mapping.html
if [ -e mapping.txt ]; then
while read line
do
echo -e "$line<br>">>report_files/sample_mapping.html
done <mapping.txt
fi
echo -e "----------------------------------------------------------------------------------</br>">>report_files/sample_mapping.html

cat <<EOF >>report_files/sample_mapping.html

<br></br></br>
Dowload the raw dataset after applying QC measures (tab delimited format, right click -> save link as)<br>
<ol>
  <li>
        <a href="../otu_table.stats" target="_blank">Sample selected and OTU stats</a>
  </li>
  <li>
        <a href="../mapping.txt" target="_blank">Mapping File</a>
</li>
</ol>
EOF

#----------Ends:Sample selected and mapping file ------------------------------#



#----------Start:Summarize taxonomy ------------------------------#

cat <<EOF >report_files/summarize_taxonomy.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Summarize taxonomies by Taxonomic distrubution"></a> &nbsp; Summarize taxonomies by Taxonomic distrubution</h2>
      </td>
    </tr>
  </tbody>
</table>

Summarize
Communities by Taxonomic Composition : Here the&nbsp;OTUs having
similar taxonomic composition are grouped together for all samples
and the results are presented as bar chart and area chart. The charts
are presented at different taxonomic levels like kingdom, phylum,
class, order, family.</p>
<p>Inside the plots, use mouse to view the taxonomic composition
of microbiome.&nbsp;</p>
<p>The identification like <span style="font-weight: bold;">"</span><span
 style="color: black;"><span style="font-weight: bold;">Root;k__Bacteria;p__Actinobacteria;c__Actinobacteria;o__Rubrobacterales;f__Rubrobacteraceae"</span>
means that it belongs to knigdom - bacteria, phylum - Actinobacteria,
class - Actinobacteria, order - Rubrobacterales and family -
Rubrobacteraceae.</span>
<h3 style="font-weight: bold; text-align: center;"><span
 style="color: rgb(153, 0, 0);">Bar Plot of Taxonomic
distribution &nbsp;&nbsp;<a
 href="../taxa_summary/taxa_summary_plots/bar_charts.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="oinw.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="../taxa_summary/taxa_summary_plots/bar_charts.html"
 scrolling="auto"></iframe><br>
<br>
<br>
<br>
<h3 style="font-weight: bold; text-align: center;"><span
 style="color: rgb(153, 0, 0);">Area Plot of Taxonomic
distribution &nbsp;<a
 href="../taxa_summary/taxa_summary_plots/area_charts.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="oinw.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="../taxa_summary/taxa_summary_plots/area_charts.html"
 scrolling="auto"></iframe><br>
<br>
<br>
<br>
<br>
</div>

EOF
#----------End:Summarize taxonomy ------------------------------#



#----------Start:Alpha diversity--------------------------------#

cat <<EOF >report_files/alpha_diversity.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Diversity within a sample (Alpha Diversity)"></a> &nbsp; Diversity within a sample (Alpha Diversity)</h2>
      </td>
    </tr>
  </tbody>
</table>

<span style="font-weight: bold; color: rgb(153, 0, 0);">Alpha
diversity</span> is used to
measure the diversity within a sample. Here we have implemented five
commonly used matrices to measure the diversity.They are<br>
<ol>
  <li>Observed_species (measure richness only)</li>
  <li>Chao1</li>
  <li>Shannon</li>
  <li>Simpson</li>
  <li>PD_whole_tree (include phylogeny).</li>
</ol>
A martix file having the alpha diversity values for all five matrices
for all samples can be downloaded <a href="../alpha_div_matrices.txt">here</a>. [The file is tab delimited and can be viewed in
excel]<br>
<br>
<span style="font-weight: bold; color: rgb(153, 0, 0);">Rarefaction
curve</span>
- Rarefaction curves plot the number of individuals sampled versus the
number of species. They're used to determine species diversity (# of
species in a community) and species richness (# of species in a given
area). When the curve starts to level off, you can assume you've
reached the approximate number of different species. Here a random
sample is genereated (without replacement) with 10% , 20%, 30% to 100%
sequences and alpha diversity is calculated for each random sample.When
the curve starts to level off, you can assume you've reached the
approximate number of different species.<br>
<br>
This rarefaction curve is dynamic in nature, please select a metric
type and category to view the results.<br>
<br>
<h3 style="font-weight: bold; text-align: center;"><span
 style="color: rgb(153, 0, 0);">Rarefaction
curve&nbsp;&nbsp;<a
 href="../alpha_rarefac/alpha_rarefaction_plots/rarefaction_plots.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="oinw.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="../alpha_rarefac/alpha_rarefaction_plots/rarefaction_plots.html"
 scrolling="auto"></iframe><br>
<br>
<br>
<br>
<br>
<br>
</div>
EOF

#----------End:Alpha Diversity ------------------------------#



#----------Start:Beta Diversity--------------------------------#


cat <<EOF >report_files/beta_diversity.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Diversity between samples (Beta Diversity)"></a> &nbsp; Diversity between samples (Beta Diversity)</h2>
      </td>
    </tr>
  </tbody>
</table>

<span style="color: rgb(153, 0, 0); font-weight: bold;">Beta
diversity</span>
is a term for the comparison of samples to each other. A beta diversity
metric does not calculate a value for each sample. Rather, it
calculates a distance between a pair of samples. &nbsp;If you have
many
samples (for example 3 control and 3 treatment), a beta diversity
metric will return a matrix of the distances of all samples to all
other samples. <br>
There are different types of matrices which can be used to measure
diversity like bray-curtis, unifrac etc.<br>
<br>
Here we have used the UniFrac matrix to calculate the beta diversity.
UniFrac is a method to calculate a distance measure between bacterial
communities using phylogenetic information. The method can be used in
two modes.<br>
<ol>
  <li>Un-weighted (Qualitative) - It depends upon&nbsp;the
present and absence of OTUs between samples and their phylogenetic
distances.</li>
  <li>Weighted (Qualitative) - It includes the abundance
information alongwith the presence and absence of OTUs between samples
and their phylogenetic distances.</li>
</ol>
Here principle coordinate analysis (PCoA) are used to vizualize
the distances between the sample. Here principle coordinate analysis
(PCoA) are used to vizualize
the distances between the samples in a 2D plot and 3D plot. <br>
<br>
<br>
<br>
<h3 style="font-weight: bold; text-align: center;"><span
 style="color: rgb(153, 0, 0);">PCoA (un-weighted) - 2D
Plots&nbsp;&nbsp;<a
 href="../beta_div/unweighted_unifrac_2d_continuous/unweighted_unifrac_pc_2D_PCoA_plots.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="oinw.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="../beta_div/unweighted_unifrac_2d_continuous/unweighted_unifrac_pc_2D_PCoA_plots.html"
 scrolling="auto"></iframe><br>
<br>
<a
 href="../beta_div/unweighted_unifrac_3d_continuous/unweighted_unifrac_pc_3D_PCoA_plots.html"
 target="_blank">Click here</a> to view PCoA
(un-weighted)&nbsp;plot in 3D [this program need Java, so please
grant the permission if asked]<br>
<br>
<br>
<h3 style="font-weight: bold; text-align: center;"><br>
<span style="color: rgb(153, 0, 0);"></span></h3>
<h3 style="font-weight: bold; text-align: center;"><span
 style="color: rgb(153, 0, 0);">PCoA (weighted) - 2D
Plots&nbsp;&nbsp;<a
 href="../beta_div/weighted_unifrac_2d_continuous/weighted_unifrac_pc_2D_PCoA_plots.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="oinw.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="../beta_div/weighted_unifrac_2d_continuous/weighted_unifrac_pc_2D_PCoA_plots.html"
 scrolling="auto"></iframe><br>
<br>
<a
 href="../beta_div/weighted_unifrac_3d_continuous/weighted_unifrac_pc_3D_PCoA_plots.html"
 target="_blank">Click here</a> to view PCoA (weighted)
plot in 3D [this program needs Java&nbsp;, so please grant the
permission if asked]<br>
<br>
<br>
<br>
<br>
</div>
EOF


#----------End:Beta Diversity--------------------------------#



#----------Start:Advance analysis--------------------------------#


cat <<EOF >report_files/advance_analysis.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="Further advanced analysis and statistical tests"></a> &nbsp; Further advanced analysis and statistical tests</h2>
      </td>
    </tr>
  </tbody>
</table>

Many different aspects of
the analysis can be explored further, if provided&nbsp;more
information about the attributes of the sample like grouping (control
vs treatment), attributes (pH, environmental factors) etc. For example
<ol>
  <li>Is there any statistical difference
between&nbsp;biological samples (control vs treatment or different
groups) based on taxonomic distribution of microbiome?&nbsp;</li>
  <li>What OTUs (species) are differentially abundant between two
groups of samples?</li>
  <li>What are the top most OTUs (or species) &nbsp;present
in a particular sample or group?</li>
  <li>What are the rare OTUs present in a particular sample or
group?</li>
  <li>OTU correlation : Is there a correlation exists between
OTUs and other arrtibutes of sample like pH or other environmental
conditions.</li>
  <li>How a group of samples behave when exposed
to&nbsp;different condition?</li>
  <li>Can we generate heatmaps with phylogenetic tree and other
attributes?</li>
  <li>Can we find what&nbsp;OTUs are shared between different
samples?</li>
  <li>How different&nbsp;samples can be group together?</li>
  <li>Can we measure alpha and beta diversity using different
matrices?
  </li>
</ol>

</div>
EOF


#----------End:Advance analysis--------------------------------#



#----------Start:References and FAQs--------------------------------#




cat <<EOF >report_files/references_faqs.html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Sample selected and mapping information</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
<span style="font-family: Verdana;"></span><br
 style="font-family: Verdana;">
<br style="font-family: Verdana;">
<div style="margin-left: 40px; font-family: Verdana;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="References and FAQs"></a> &nbsp; References and FAQs</h2>
      </td>
    </tr>
  </tbody>
</table>

</span></p>
<div style="text-align: left;"><span
 style="font-weight: bold;">
<h3 style="font-weight: bold; text-align: left;"><span
 style="color: rgb(153, 0, 0);">References&nbsp;&nbsp;
</span></h3>
</span></div>
Major part of the analysis done here was carried using QIIME package
for microbial population analysis. However many other aspects of
analysis were&nbsp;done using R, bash script, Perl and other
bioinformatics packages like FASTQC, FASTX, GALAXY.&nbsp;
<ol>
  <li><a
 href="http://www.nature.com/nmeth/journal/v7/n5/full/nmeth.f.303.html">QIIME</a>
allows analysis of high-throughput community
sequencing data<br>
J Gregory Caporaso, Justin Kuczynski, Jesse Stombaugh, Kyle
Bittinger, Frederic D Bushman, Elizabeth K Costello, Noah Fierer,
Antonio Gonzalez Pena, Julia K Goodrich, Jeffrey I Gordon, Gavin A
Huttley, Scott T Kelley, Dan Knights, Jeremy E Koenig, Ruth E Ley,
Catherine A Lozupone, Daniel McDonald, Brian D Muegge, Meg Pirrung,
Jens Reeder, Joel R Sevinsky, Peter J Turnbaugh, William A Walters,
Jeremy Widmann, Tanya Yatsunenko, Jesse Zaneveld and Rob Knight; Nature
Methods, 2010; doi:10.1038/nmeth.f.303</li>
  <li><a
 href="http://www.bioinformatics.babraham.ac.uk/projects/fastqc/">FASTQC</a></li>
  <li><a href="http://hannonlab.cshl.edu/fastx_toolkit/">FASTX</a></li>
  <li><a href="http://cran.r-project.org/">R</a></li>
  <li><a href="http://www.perl.org/">PERL</a></li>
</ol>
<br><h3 style="text-align: left;"><span
 style="color: rgb(153, 0, 0);">Tutorial&nbsp;&nbsp;&nbsp;</span></h3>
<a href="#Index"><img
 style="border: 0px solid ; width: 42px; height: 42px; float: right;"
 alt="" src="report_files/arrow.png"></a><br>
Here are the workflow on microbiome analysis <a
 href="https://dl.dropbox.com/u/428435/poster-microbiome.pptx"
 target="_blank">PPT</a> &nbsp;<a
 href="https://dl.dropbox.com/u/428435/poster-microbiome.pdf"
 target="_blank">PDF</a><br>
<br>
<br>
<span style="font-weight: bold;"><a
 name="What_is_Alpha_diversity"></a>What is Alpha
diversity</span> - It is
used to measure the diversity within a sample. For measuring alpha
diversity, two major factors taken into account are richness and
evenness. <br>
Richness is a measure of &nbsp;number of
&nbsp;species present in a
sample. <br>
Evenness is a measure of relative abundance of different
species that make up the richness in that area.
Evenness is ranged from zero to one. When evenness is close to zero, it
indicates that most of the individuals belongs to one or a few
species/categories. When the evenness is close to one, it indicates
that each species/categories consists of the same number of individuals.<br>
<br>
Consider this example of finding the alpha diversity in two samples.<br>
<br>
<table valign="top"
 style="border: 0pt solid rgb(163, 163, 163); direction: ltr; border-collapse: collapse; background-color: rgb(237, 237, 237);"
 border="1" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Flower Species </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
Sample 1 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
Sample 2 </th>
    </tr>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Daisy </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
300 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
20 </th>
    </tr>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Dandelion </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
335 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
49 </th>
    </tr>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Buttercup </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
365 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
931 </th>
    </tr>
    <tr>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 1.2569in;">
Total </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9083in;">
1000 </th>
      <th
 style="border-width: 0pt; padding: 4pt; vertical-align: top; width: 0.9in;">
1000 </th>
    </tr>
  </tbody>
</table>
<br>
Here both samples have the same richness (3 species) and
the same total number of individuals (1000). However, the first sample
has more evenness than the second.
This is because the total number of individuals in the sample is quite
evenly
distributed between the three species.<br>
As species richness and evenness increase, so
diversity increases.<br>
<br>
Several
biodiversity indices have been developed that mathematically combine
the effects of richness and eveness. Each has its merits, and may put
more or less emphasis upon richness or eveness.<br>
<br>
A diversity
index is a quantitative measure that reflects how many different types
(such as species) there are in a dataset, and simultaneously takes into
account how evenly the basic entities (such as individuals) are
distributed among those types. The value of a diversity index increases
both when the number of types increases and when evenness increases.
For a given number of types, the value of a diversity index is
maximized when all types are equally abundant.<br>
<br>
Observed_species index measures species richness (S), which is the
total number of species found in an environment/sample.<br>
Simpson's index (D) is the probability that two randomly selected
individuals belong to two different species/categories.<br>
Shannon-Wiener
index (H) is measuring the order/disorder in a particular system. This
order is characterized by the number of individuals found for each
species/category in the sample. A high species diversity may indicate
generally a healthy environment.<br>
<br>
The list of indexes supported here are &nbsp;<span
 style="font-weight: bold;">ACE,
berger_parker_d, brillouin_d, chao1, chao1_confidence, dominance,
doubles, equitability, fisher_alpha, heip_e, kempton_taylor_q,
margalef, mcintosh_d, mcintosh_e, menhinick, michaelis_menten_fit,
observed_species, osd, reciprocal_simpson, robbins, shannon, simpson,
simpson_e, singles, strong, PD_whole_tree</span><br>
<br>
<br>
<br>
<span style="font-weight: bold;">Rarefaction curve</span>
-
Rarefaction curves plot the number of individuals sampled versus the
number of species. They're used to determine species diversity (# of
species in a community) and species richness (# of species in a given
area). When the curve starts to level off, you can assume you've
reached the approximate number of different species. Here a random
sample is genereated (without replacement) with 10% , 20%, 30% to 100%
sequences and alpha diversity is calculated for each random sample.When
the curve starts to level off, you can assume you've reached the
approximate number of different species.<br>
<br>
This rarefaction curve is dynamic in nature, please select a metric
type and category to view the results.<br>
<br>
<br>
Source : &nbsp;<br>
<a href="http://en.wikipedia.org/wiki/Diversity_index">http://en.wikipedia.org/wiki/Diversity_index</a><br>
<a href="http://www.countrysideinfo.co.uk/simpsons.htm">http://www.countrysideinfo.co.uk/simpsons.htm</a><br>
<a href="http://aquafind.com/articles/Biodiversity-Indices.php">http://aquafind.com/articles/Biodiversity-Indices.php</a><br>
<a href="qiime.org/scripts/alpha_diversity.html">qiime.org/scripts/alpha_diversity.html</a><br>
<br>
<br>
<a href="#Index"><img
 style="border: 0px solid ; width: 42px; height: 42px; float: right;"
 alt="" src="report_files/arrow.png"></a><br>
<span style="font-weight: bold;"><a
 name="What_is_Beta_diversity"></a>What is Beta
diversity</span> - It is a term for the comparison of samples to
each other. A beta diversity metric does not calculate a value for each
sample. Rather, it calculates a distance between a pair of
samples.&nbsp; If you have many samples (for example 3 control and
3 treatment), a beta diversity metric will return a matrix of the
distances of all samples to all other samples.<br>
There are different types of matrices which can be used to measure
diversity like bray-curtis, unifrac etc.<br>
Different typr of matrices supported here are <br>
<span style="font-weight: bold;">abund_jaccard,
binary_chisq, binary_chord, binary_euclidean, binary_hamming,
binary_jaccard, binary_lennon, binary_ochiai, binary_otu_gain,
binary_pearson, binary_sorensen_dice, bray_curtis, canberra, chisq,
chord, euclidean, gower, hellinger, kulczynski, manhattan,
morisita_horn, pearson, soergel, spearman_approx, specprof, unifrac,
unifrac_g, unifrac_g_full_tree, unweighted_unifrac,
unweighted_unifrac_full_tree, weighted_normalized_unifrac,
weighted_unifrac</span><br>
<br>
<br>
Here we generally use the UniFrac matrix to calculate the beta
diversity. UniFrac is a method to calculate a distance measure between
bacterial communities using phylogenetic information. The method can be
used in two modes.<br>
<ol>
  <li>Un-weighted (Qualitative) - It depends upon the present and
absence of OTUs between samples and their phylogenetic distances.</li>
  <li>Weighted (Qualitative) - It includes the abundance
information alongwith the presence and absence of OTUs between samples
and their phylogenetic distances.</li>
</ol>
Here principle coordinate analysis (PCoA) are used to vizualize the
distances between the sample. Here principle coordinate analysis (PCoA)
are used to vizualize the distances between the samples in a 2D plot
and 3D plot. <br>
<br>
Source<br>
<a href="http://www.wernerlab.org/teaching/qiime/overview/f">http://www.wernerlab.org/teaching/qiime/overview/f</a><br>
<a
 href="http://qiime.org/tutorials/tutorial.html#compute-beta-diversity-and-generate-beta-diversity-plots">http://qiime.org/tutorials/tutorial.html#compute-beta-diversity-and-generate-beta-diversity-plots</a><br>
<a href="http://en.wikipedia.org/wiki/UniFrac">http://en.wikipedia.org/wiki/UniFrac</a><br>
<a href="http://bmf2.colorado.edu/unifrac/tutorial.psp">http://bmf2.colorado.edu/unifrac/tutorial.psp</a><br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
</div>
</body>
</html>
EOF

#----------Start:References and FAQs--------------------------------#



echo "Report generated in folder 'microbiome_report.html'";
