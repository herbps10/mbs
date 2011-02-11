library(getopt)

opt <- getopt(c(
	"populationsize", "s", 1, "integer", 
	"unvaccinated", "u", 1, "integer", 
	"infectious", "i", 1, "integer", 
	"frames", "f", 1, "integer",
	"animation", "a", 0, "logical",
	"datafile", "d", 0, "logical"
))

POPULATION_SIZE = opt$populationsize
NUMBER_UNVACCINATED = opt$unvaccinated
NUMBER_INFECTIOUS = opt$infectious

ANIMATION_FRAMES = opt$frames

CREATE_ANIMATION = opt$animation
CREATE_DATAFILE = opt$datafile
