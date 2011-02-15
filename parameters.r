# -------------- parameters.r ---------------- #
# 					       #
# This file initializes the parameters	       #
# for the model. 			       #
# 					       #
# You can load this file then use getopt.r     #
# To overwrite some of the parameters with     #
# command line arguments.		       #
#					       #
# -------------------------------------------- #

# General configuration
POPULATION_SIZE = 50
NUMBER_UNVACCINATED = 10 # The amount of people that start as being unvaccinated
NUMBER_INFECTIOUS = 4 # The amount of people that start as infectious
LENGTH_OF_INFECTION = 10
LENGTH_OF_RECOVERY = -1 # Set to -1 to make permanent

TIME_TO_INFECT = 4 # The number of frames to wait until the infection is spread to connecting nodes. Use this to slow down the resulting animation. Set to -1 to disable.

DATA_OUTPUT = "/home/hps1/vaccines/sinatra/public/data/"

GRAPH_GENERATOR = "/home/hps1/vaccines/graph_generators/barabasi.r"

# Used for configuring the animation
#ANIMATION_OUTPUT = "/home/herb/Dropbox/School/Freshmen/Spring/Modeling-Biological-Systems/vaccines/sinatra/public/animation/"
ANIMATION_OUTPUT = "/home/hps1/vaccines/sinatra/public/animation/"
ANIMATION_FRAMES = 30
ANIMATION_OUTPUT_DATA = F

# Used for configuring data collection
SIMULATION_OUTPUT_DATA = F
SIMULATION_LENGTH = 50 # How long the simulation should run
SIMULATION_REPEAT = 10 # How many times to repeat the simulation
