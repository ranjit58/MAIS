echo "Creating HTML report for the current folder ...";
mkdir report
cp -r fastqc_afterqc/ report/fastqc_afterqc
cp -r fastqc_beforeqc/ report/fastqc_beforeqc
cp -r taxa_summary/ report/taxa_summary
cp -r alpha_rarefac/ report/alpha_rarefac
cp -r beta_div/ report/beta_div
cp alpha_div_matrices report/alpha_div_matrices.txt
cp otu_table.stats report/otu_table.stats 
cp ~/workdir/my-scripts/cheaha/arrow.png report/
cp ~/workdir/my-scripts/cheaha/open-in-new-window.gif report/
cp ~/workdir/my-scripts/cheaha/q.jpg report/

cat <<EOF >report/microbiome_result.html
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>microbiome_results</title>
</head>
<body
 style="background-color: white; width: 1200px; color: rgb(0, 0, 0);"
 alink="#ee0000" link="#0000ee" vlink="#551a8b">
&nbsp;
<h1
 style="text-align: center; font-weight: normal; margin-left: 40px; color: white; background-color: rgb(102, 102, 102);"><a
 name="Index"></a>Microbiome
Analysis Results</h1>
<br><div style="margin-left: 40px;">
<h2><span style="font-weight: normal;">Index</span></h2>
</div>
<ol style="margin-left: 40px; background-color: white;">
  <li><a href="#1._Samples_and_sequencing_overview">Samples
and
sequencing
overview</a></li>
  <li style="width: 1200px;"><a
 href="#2._Quality_Control">Quality
Control</a></li>
  <li><a href="#3._Summarize_taxonomies_by_Taxonomic">Summarize
communities by Taxonomic distribution</a></li>
  <li><a href="#4._Diversity_within_a_sample_Alpha">Diversity
within a sample (Alpha Diversity)</a></li>
  <li><a href="#5._Diversity_between_samples_Beta">Diversity
between samples (Beta Diversity)</a></li>
  <li><a href="#6._Further_advanced_analysis_and">Further
advanced
analysis
and statistical tests</a></li>
  <li><a href="#7._References_and_FAQs">References
and Tutorial</a></li>
</ol>
<br>
<div style="margin-left: 40px;">
<img style="width: 32px; height: 32px;" alt=""
 src="arrow.png" align="middle"> &nbsp;This icon
brings you to the top index page.<br>
<img style="width: 35px; height: 35px;" alt=""
 src="q.jpg" align="middle"> This will open the help
page for that topic (if any)<br>
<img style="width: 35px; height: 35px;" alt=""
 src="open-in-new-window.gif" align="middle"> This
will open the webpage or graphs in a new browser tab/window<br>
</div>
<br>
<br>
<div style="margin-left: 40px;"><span
 style="color: black;"></span>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="1._Samples_and_sequencing_overview"></a>1.
Samples and sequencing overview</h2>
      </td>
      <td style="width: 3%;"><a href="#Index"><img
 style="border: 0px solid ; width: 34px; height: 34px;" alt=""
 src="arrow.png" align="middle"></a><br>
      </td>
      <td style="width: 3%;"><img
 style="width: 38px; height: 38px;" alt="" src="q.jpg"
 align="middle"></td>
    </tr>
  </tbody>
</table>
<span style="color: black;">
This
section describes the&nbsp;samples and their sequencing results. It
shows the number of samples, sequences per
sample and a table with their initial quality statistics.</span><br>
<br>
<!--xxxxxxxxxxxxxxxxxxxxxxxx  INSERT  xxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
EOF

if [ -e report/fastqc_beforeqc/qcstats.txt ]; then
echo -e '<table style="text-align: left; width: 900px; height: 61px;margin-left: 60px;" border="1" cellpadding="2" cellspacing="1">'>>report/microbiome_result.html
echo -e "<thead><tr><th>Count</th><th>Sample Name</th><th>Sequences </th><th>Read Length </th> <th>GC Content </th><th> FastQC Plots</th></tr> </thead><tbody>">>report/microbiome_result.html
COUNT=1;
while read line
do
	arrIN=(${line/// })
fastqclink=${arrIN[0]/.fastq/}
echo "<tr><td>${COUNT}</td><td>${arrIN[0]}</td><td>${arrIN[1]}</td><td>${arrIN[2]}</td><td>${arrIN[3]}</td><td><a href=\"fastqc_beforeqc/${fastqclink}_fastqc/fastqc_report.html\" target=\"_blank\">FASTQC</a></tr>">>report/microbiome_result.html
COUNT=$(($COUNT + 1 ));
done <report/fastqc_beforeqc/qcstats.txt
echo "</tbody></table>">>report/microbiome_result.html
fi
cat <<EOF >>report/microbiome_result.html
<br>
<br>
<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="fastqc_beforeqc/FASTQCplot.png"><br>
<br><a href="fastqc_beforeqc/qcstats.txt" target="_blank">Click here</a> to download the sample statistics table before QC
<br><a href="fastqc_beforeqc/qcplot.txt" target="_blank">Click here</a> to download per base sequence quality file before QC
<br>
<br>
</div>
<div style="margin-left: 40px;">
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="2._Quality_Control"></a>2.
Quality Control</h2>
      </td>
      <td style="width: 3%;"><a href="#Index"><img
 style="border: 0px solid ; width: 34px; height: 34px;" alt=""
 src="arrow.png" align="middle"></a><br>
      </td>
      <td style="width: 3%;"><img
 style="width: 38px; height: 38px;" alt="" src="q.jpg"
 align="middle"></td>
    </tr>
  </tbody>
</table>
<span style="color: black;">This section presents the
Quality
control measures taken&nbsp;beore the data analysis. </span><br
 style="color: black;">
<br style="color: black;">
<span style="color: black;"><b>QC Method : </b></span>The
first 10 bases of
all reads are trimmed because of less diversity and sequence quality
issue. Remaining read length is 55bases. We discard any read which has
N character as a base. For any read 90% of bases should have quality
threshold Q&gt;30.<br>
<br>
Here is the sequence statistics after applying the QC measures.<br>
<br>
<!--xxxxxxxxxxxxxxxxxxxxxxxx  INSERT  xxxxxxxxxxxxxxxxxxxxxxxxxxxxx -->
EOF

if [ -e report/fastqc_afterqc/qcstats.txt ]; then
echo -e '<table style="text-align: left; width: 900px; height: 61px;margin-left: 60px;" border="1" cellpadding="2" cellspacing="1">'>>report/microbiome_result.html
echo -e "<thead><tr><th>Count</th><th>Sample Name</th><th>Sequences </th><th>Read Length </th> <th>GC Content </th><th> FastQC Plots</th></tr> </thead><tbody>">>report/microbiome_result.html
COUNT=1;
while read line
do
        arrIN=(${line/// })
fastqclink=${arrIN[0]/.fastq/}
echo "<tr><td>${COUNT}</td><td>${arrIN[0]}</td><td>${arrIN[1]}</td><td>${arrIN[2]}</td><td>${arrIN[3]}</td><td><a href=\"fastqc_afterqc/${fastqclink}_fastqc/fastqc_report.html\" target=\"_blank\">FASTQC</a></tr>">>report/microbiome_result.html
COUNT=$(($COUNT + 1 ));
done <report/fastqc_afterqc/qcstats.txt
echo "</tbody></table>">>report/microbiome_result.html
fi
cat <<EOF >>report/microbiome_result.html
<br>
<br>
<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="fastqc_afterqc/FASTQCplot.png"><br>
<br><a href="fastqc_afterqc/qcstats.txt" target="_blank">Click here</a> to download the sample statistics table after QC
<br><a href="fastqc_afterqc/qcplot.txt" target="_blank">Click here</a> to download per base sequence quality file after QC
<br>
<br>
EOF

echo '<br>------<b>Samples selected for analysis and their clustering (OTUs) stats</b>--------------<br><br>'>>report/microbiome_result.html
if [ -e report/otu_table.stats ]; then
while read line
do
echo -e "$line<br>">>report/microbiome_result.html
done <report/otu_table.stats
fi

echo '-------------------------------------------------------------<br><br>'>>report/microbiome_result.html

cat <<EOF >>report/microbiome_result.html
</div>
<div style="margin-left: 40px;">
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="3._Summarize_taxonomies_by_Taxonomic"></a>3.
Summarize taxonomies by Taxonomic distrubution</h2>
      </td>
      <td style="width: 3%;"><a href="#Index"><img
 style="border: 0px solid ; width: 34px; height: 34px;" alt=""
 src="arrow.png" align="middle"></a><br>
      </td>
      <td style="width: 3%;"><img
 style="width: 38px; height: 38px;" alt="" src="q.jpg"
 align="middle"></td>
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
 href="taxa_summary/taxa_summary_plots/bar_charts.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="open-in-new-window.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="taxa_summary/taxa_summary_plots/bar_charts.html"
 scrolling="auto"></iframe><br>
<br>
<br>
<br>
<h3 style="font-weight: bold; text-align: center;"><span
 style="color: rgb(153, 0, 0);">Area Plot of Taxonomic
distribution &nbsp;<a
 href="taxa_summary/taxa_summary_plots/area_charts.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="open-in-new-window.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="taxa_summary/taxa_summary_plots/area_charts.html"
 scrolling="auto"></iframe><br>
<br>
<br>
<br>
<br>
</div>
<div style="margin-left: 40px;">
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="4._Diversity_within_a_sample_Alpha"></a>4.
Diversity within a sample (Alpha Diversity)</h2>
      </td>
      <td style="width: 3%;"><a href="#Index"><img
 style="border: 0px solid ; width: 34px; height: 34px;" alt=""
 src="arrow.png" align="middle"></a><br>
      </td>
      <td style="width: 3%;"><a
 href="#What_is_Alpha_diversity"><img
 style="border: 0px solid ; width: 38px; height: 38px;" alt=""
 src="q.jpg" align="middle"></a></td>
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
for all samples can be downloaded <a href="alpha_div_matrices.txt">here</a>. [The file is tab delimited and can be viewed in
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
 href="alpha_rarefac/alpha_rarefaction_plots/rarefaction_plots.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="open-in-new-window.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="alpha_rarefac/alpha_rarefaction_plots/rarefaction_plots.html"
 scrolling="auto"></iframe><br>
<br>
<br>
<br>
<br>
<br>
</div>
<div style="margin-left: 40px;"><br>
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="5._Diversity_between_samples_Beta"></a>5.
Diversity between samples (Beta Diversity)</h2>
      </td>
      <td style="width: 3%;"><a href="#Index"><img
 style="border: 0px solid ; width: 34px; height: 34px;" alt=""
 src="arrow.png" align="middle"></a><br>
      </td>
      <td style="width: 3%;"><a
 href="#What_is_Beta_diversity"><img
 style="border: 0px solid ; width: 38px; height: 38px;" alt=""
 src="q.jpg" align="middle"></a></td>
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
 href="beta_div/unweighted_unifrac_2d_continuous/unweighted_unifrac_pc_2D_PCoA_plots.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="open-in-new-window.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="beta_div/unweighted_unifrac_2d_continuous/unweighted_unifrac_pc_2D_PCoA_plots.html"
 scrolling="auto"></iframe><br>
<br>
<a
 href="beta_div/unweighted_unifrac_3d_continuous/unweighted_unifrac_pc_3D_PCoA_plots.html"
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
 href="beta_div/weighted_unifrac_2d_continuous/weighted_unifrac_pc_2D_PCoA_plots.html"
 target="_blank"><img
 style="border: 0px solid ; width: 36px; height: 36px;"
 alt="open_in_new_window" src="open-in-new-window.gif"></a>
</span></h3>
<iframe
 style="border: 2px solid rgb(0, 0, 0); width: 100%; height: 700px;"
 src="beta_div/weighted_unifrac_2d_continuous/weighted_unifrac_pc_2D_PCoA_plots.html"
 scrolling="auto"></iframe><br>
<br>
<a
 href="beta_div/weighted_unifrac_3d_continuous/weighted_unifrac_pc_3D_PCoA_plots.html"
 target="_blank">Click here</a> to view PCoA (weighted)
plot in 3D [this program needs Java&nbsp;, so please grant the
permission if asked]<br>
<br>
<br>
<br>
<br>
</div>
<div style="margin-left: 40px;">
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="6._Further_advanced_analysis_and"></a>6.
Further advanced analysis and statistical tests</h2>
      </td>
      <td style="width: 3%;"><a href="#Index"><img
 style="border: 0px solid ; width: 34px; height: 34px;" alt=""
 src="arrow.png" align="middle"></a><br>
      </td>
      <td style="width: 3%;"><img
 style="width: 38px; height: 38px;" alt="" src="q.jpg"
 align="middle"></td>
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
<div style="margin-left: 40px;"><br>
<p><span style="font-weight: bold;">
<table style="text-align: left; width: 1160px; height: 54px;"
 border="0" cellpadding="0" cellspacing="0">
  <tbody>
    <tr>
      <td style="color: white;">
      <h2
 style="background-color: rgb(102, 102, 102); font-weight: normal;"><a
 name="7._References_and_FAQs"></a>7.
References and FAQs</h2>
      </td>
      <td style="width: 3%;"><a href="#Index"><img
 style="border: 0px solid ; width: 34px; height: 34px;" alt=""
 src="arrow.png" align="middle"></a><br>
      </td>
      <td style="width: 3%;"><img
 style="width: 38px; height: 38px;" alt="" src="q.jpg"
 align="middle"></td>
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
 alt="" src="arrow.png"></a><br>
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
 alt="" src="arrow.png"></a><br>
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
echo "Report generated in folder 'report/microbiome_result.html'";
