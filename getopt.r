# --------------------------- get.r ------------------------------ #
# 								   #
# This file handles parsing parameters from the command line. 	   #
#								   #
# Sinatra uses command line arguments to set the model parameters. #
# It would be really cumbersome to set all these arguments	   #
# manually on the command line. Setup your parameters in the       #
# parameters.r file instead.					   #
#							   	   #
# ---------------------------------------------------------------- #

library(getopt)

opt <- getopt(c(
	"populationsize", "s", 1, "integer", 
	"unvaccinated", "u", 1, "integer", 
	"infectious", "i", 1, "integer", 

	"infectionlength", "l", 1, "integer",
	"recoverylength", "r", 1, "integer",
	
	"timetoinfect", "t", 1, "integer",
	
	"frames", "f", 1, "integer",

	"graph", "g", 1, "character",

	"animation", "a", 0, "logical",
	"datafile", "d", 0, "logical"
))

POPULATION_SIZE = opt$populationsize
NUMBER_UNVACCINATED = opt$unvaccinated
NUMBER_INFECTIOUS = opt$infectious

LENGTH_OF_INFECTION = opt$infectionlength
LENGTH_OF_RECOVERY = opt$recoverylength

TIME_TO_INFECT = opt$timetoinfect

ANIMATION_FRAMES = opt$frames

CREATE_ANIMATION = opt$animation

CREATE_DATAFILE = opt$datafile

GRAPH_GENERATOR = opt$graph


if(CREATE_ANIMATION == T) {
	ANIMATION_OUTPUT_DATA = CREATE_DATAFILE
}
