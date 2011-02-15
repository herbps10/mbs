# --------------------------- many.r ---------------------------- #
# 								  #
# This file will run multiple simulations. 		   	  #
# It can only output a master data file for all the simulations.  #
#							   	  #
# --------------------------------------------------------------- #

source("vaccinations.r")

dataPath = paste(c(DATA_OUTPUT, "output.dat"), sep="", collapse="")

g = initGraph()

# Output the table header to the file
cat("\tS\tI\tR\n", file=dataPath)

for(simulation in c(1:SIMULATION_REPEAT)) {
	for(frame in c(1:SIMULATION_LENGTH)) {
		# Count the number in each state and output to the table
		cat(file=dataPath, append=T, frame, "\t", inDiseaseState(g, "S"), "\t", inDiseaseState(g, "I"), "\t", inDiseaseState(g, "R"), "\n")

		# Output the current timestep to the screen
		cat(frame, "\n")

		g = timeStep(g)
	}
}
