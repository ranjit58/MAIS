#!/usr/bin/perl
$start = $ARGV[1];$start--;
$end = $ARGV[2];

open(IN,"<$ARGV[0]") or die "input file not found";

#print " $ARGV[0], $ARGV[1], $ARGV[2]";
while (<IN>) {
chomp $_;
if ($_ =~ />/) {
print "$_\n";
}
else {
my @arr = split("",$_);
for(my $i = $start ; $i < $end; $i++) {
print "$arr[$i]";
}
print "\n";
}
}
