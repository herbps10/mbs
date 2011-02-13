source("vaccinations.r")

dataPath = paste(c(DATA_OUTPUT, "output.dat"), sep="", collapse="")

g = initGraph()

cat("\tS\tI\tR\n", file=dataPath)

for(simulation in c(1:SIMULATION_REPEAT)) {
	for(frame in c(1:SIMULATION_LENGTH)) {
		# Count the number in each state
		cat(file=dataPath, append=T, frame, "\t", inDiseaseState(g, "S"), "\t", inDiseaseState(g, "I"), "\t", inDiseaseState(g, "R"), "\n")

		# Output the current timestep to the screen
		cat(frame, "\n")

		g = timeStep(g)
	}
}
