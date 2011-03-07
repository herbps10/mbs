# -------------------- one.r ----------------------#
# 						   #
# This file will run one simulation. 		   #
# It can output an animation, data file, or both.  #
#						   #
# -------------------------------------------------#

library(animation)
library(igraph)

# the function initGraph should come from a graph generator R file
g = initGraph(0.5)

# Create the layout for the graph once
lay = layout.fruchterman.reingold(g)

par(mfrow = c(1, 1))

# Set up the animation settings
oopt = ani.options(interval = 0.1, outdir = ANIMATION_OUTPUT, ani.width=1000, ani.height = 800)
ani.start()

plotGraph(g, lay, 0)

if(ANIMATION_OUTPUT_DATA == T) {
	# Initialize the data output file

	dataPath = paste(c(DATA_OUTPUT, "output.dat"), sep="", collapse="") # Figure out the path to the data output file
	cat("\tS\tI\tR\n", file=dataPath) # Write the table header to the file
}

# We haven't started producing animation frames yet, so the percentage complete is 0
cat(0, "\n") 

for(n in c(1:ANIMATION_FRAMES)) {
	g = timeStep(g) # The timeStep is the main element of the model. It modifies the graph depending on the rules of the model.

	plotGraph(g, lay, n)

	if(ANIMATION_OUTPUT_DATA == T) {
		# Print out this line in the table
		cat(file=dataPath, append=T, n, "\t", inDiseaseState(g, "S"), "\t", inDiseaseState(g, "I"), "\t", inDiseaseState(g, "R"), "\n")
	}

	# Print out percentage frames complete
	cat((100*n)/ANIMATION_FRAMES, "\n")
}

# Indicate that the simulation is done running
cat(100, "\n") 

ani.stop()
ani.options(oopt)
