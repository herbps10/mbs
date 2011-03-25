library(plyr)
data = read.csv("data no vaccines.csv", sep=" ")


max.infected = ddply(data, c("power", "edge"), function(df)c(df$max.infected))

max.infected.one.edge = max.infected[which(max.infected$edge == 1), ]

boxplot(as.matrix(max.infected.one.edge[2:11]), use.cols=F, axes=F, xlab="Power", ylab="Maximum Number Infected")
axis(1, at=1:length(max.infected.one.edge$power), labels=max.infected.one.edge$power)
axis(2)
title("Maximum Number Infected versus Power\nOne Edge")

