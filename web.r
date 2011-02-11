# Load the core script
source("/home/hps1/vaccines/vaccinations.r")

# Load default parameters
source("/home/hps1/vaccines/parameters.r")

# This will overwrite the default parameters with command line arguments
source("/home/hps1/vaccines/getopt.r")

print(CREATE_ANIMATION)

if(CREATE_ANIMATION == T) {
	source("/home/hps1/vaccines/animate.r")
}