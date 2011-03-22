mat = as.matrix(read.csv("No vaccinations small changes in power.csv", sep=";"))

start.edges = c(14, 27)
metrics = mat[, 1][start.edges[1]:(start.edges[1]+5)]

powers = as.numeric(mat[10, 2:length(mat[10,])])

m = 0
for(metric in metrics) {
	for(edge in 1:2) {
		png(paste("output/", metric, " edge ", edge, ".png"))
		data = mat[start.edges[edge] + m, 2:length(mat[start.edges[edge],])]
		plot(x = powers, y = data, xlab="Power", ylab=metric, col.main="black")
		dev.off()
	}
	m = m + 1
}

maxinfected1 = as.numeric(mat[15, 2:length(mat[15,])])
maxinfected2 = as.numeric(mat[28, 2:length(mat[28,])])

data = data.frame(powers, maxinfected1, maxinfected2)

p = ggplot(data, aes(powers, maxinfected1))
p = p + geom_point(colour="blue")
p = p + geom_point(aes(powers, maxinfected2), colour="red")
p = p + opts(title="Test", size=I(10)) 
p = p + scale_x_continuous("Power") + scale_y_continuous("Max Infected Percentage")