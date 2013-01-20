png(filename = "hist.png",width = 1000, height = 700)
raw_data <- read.table(file="qcstats.txt",header=T,sep="\t")  #read file
hist(raw_data[,2],breaks=100, col="lightblue", main="Read depth vs Sample", xlab="read depth", ylab="sample count")
box()
dev.off()
