library(animation)

g = initGraph()

lay = layout.fruchterman.reingold(g)
par(mfrow = c(1, 1))
oopt = ani.options(interval = 0.1, outdir = ANIMATION_OUTPUT, ani.width=1000, ani.height = 800)
ani.start()

plotGraph(g, lay, 0)

if(ANIMATION_OUTPUT_DATA == T) {
	dataPath = paste(c(DATA_OUTPUT, "output.dat"), sep="", collapse="")
	cat("\tS\tI\tR\n", file=dataPath)
}

cat(0, "\n")
for(n in c(1:ANIMATION_FRAMES)) {
	g = timeStep(g)
	plotGraph(g, lay, n)

	if(ANIMATION_OUTPUT_DATA == T) {
		cat(file=dataPath, append=T, n, "\t", inDiseaseState(g, "S"), "\t", inDiseaseState(g, "I"), "\t", inDiseaseState(g, "R"), "\n")
	}

	if(n %% 5 == 0) {
		cat((100*n)/ANIMATION_FRAMES, "\n")
	}
}
cat(100, "\n")

ani.stop()
ani.options(oopt)
