source("parameters.r")

data = read.table(paste(DATA_OUTPUT, "output.dat", sep=""), header=T, sep="\t")
attach(data)

cat(mean(data[T == 50,,]$R), "\n")
