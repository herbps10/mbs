library(getopt)

opt <- getopt(c(
	"populationsize", "s", 1, "integer", 
	"unvaccinated", "u", 1, "integer", 
	"infectious", "i", 1, "integer", 
	"animationframes", "f", 1, "integer",
	"animation", "a", 0, "logical",
	"datafile", "d", 0, "logical"
))

POPULATION_SIZE = opt$populationsize
NUMBER_UNVACCINATED = opt$unvaccinated
NUMBER_INFECTIOUS = opt$infectious

ANIMATION_FRAMES = opt$animationframes
