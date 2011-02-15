# ------------------------ cmd.r ------------------------ #
# 							  #
# This is a helper file that allows you to run a single   #
# simulation from the command line using the parameters   #
# defined in parameters.r 				  #
#							  #
# ------------------------------------------------------- #

# Load the core script
source("/home/hps1/vaccines/vaccinations.r")

# Load default parameters
source("/home/hps1/vaccines/parameters.r")

# Load the graph generator
source(GRAPH_GENERATOR)

source("/home/hps1/vaccines/one.r")
