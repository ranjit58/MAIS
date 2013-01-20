echo "Creating HTML report for the current folder ...";
mkdir report
cp -rv fastqc_afterqc/ report/
rm -v report/fastqc_afterqc/*.zip
cp -rv fastqc_beforeqc/ report/fastqc_beforeqc
rm -v report/fastqc_beforeqc/*.zip
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
 name="Index"></a>Microbiome Data Overview</h1>
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
echo '<h4> Total number of reads are - '>>report/microbiome_result.html
echo `cat report/fastqc_beforeqc/qcstats.txt | cut -f 2 |awk '{total = total + $1}END{print total}'`>>report/microbiome_result.html
echo '</h4>'>>report/microbiome_result.html

echo '<h4> Total number of samples are - '>>report/microbiome_result.html
echo `cat report/fastqc_beforeqc/qcstats.txt | cut -f 2 |awk '{count++}END{print count}'`>>report/microbiome_result.html
echo '</h4>'>>report/microbiome_result.html

echo '<h4> Average number of reads per sample is '>>report/microbiome_result.html
echo `cat report/fastqc_beforeqc/qcstats.txt | cut -f 2 |awk '{total = total + $1;count++}END{print total/count}'`>>report/microbiome_result.html
echo '</h4>'>>report/microbiome_result.html


cat <<EOF >>report/microbiome_result.html
<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="fastqc_beforeqc/hist.png"><br>
<br>
<br>
<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="fastqc_beforeqc/FASTQCplot.png"><br><br><br>
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

echo '<h4> Total number of reads are - '>>report/microbiome_result.html
echo `cat report/fastqc_afterqc/qcstats.txt | cut -f 2 |awk '{total = total + $1}END{print total}'`>>report/microbiome_result.html
echo '</h4>'>>report/microbiome_result.html

echo '<h4> Total number of samples are - '>>report/microbiome_result.html
echo `cat report/fastqc_afterqc/qcstats.txt | cut -f 2 |awk '{count++}END{print count}'`>>report/microbiome_result.html
echo '</h4>'>>report/microbiome_result.html

echo '<h4> Average number of reads per sample is '>>report/microbiome_result.html
echo `cat report/fastqc_afterqc/qcstats.txt | cut -f 2 |awk '{total = total + $1;count++}END{print total/count}'`>>report/microbiome_result.html
echo '</h4>'>>report/microbiome_result.html

cat <<EOF >>report/microbiome_result.html
<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="fastqc_afterqc/hist.png"><br>
<br>
<br>
<br>
<img style="width: 1000px; height: 700px;" alt=""
 src="fastqc_afterqc/FASTQCplot.png"><br><br><br><br>
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
<br><a href="fastqc_afterqc/qcstats.txt" target="_blank">Click here</a> to download the sample statistics table after QC
<br><a href="fastqc_afterqc/qcplot.txt" target="_blank">Click here</a> to download per base sequence quality file after QC
<br>
<br>
EOF
