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
POPULATION_SIZE = 300
NUMBER_VACCINATED = 0 # The number of people to start as vaccinated
NUMBER_INFECTIOUS = 0.05 * POPULATION_SIZE # The amount of people that start as infectious
LENGTH_OF_RECOVERY = 0 # Set to -1 to make permanent

TIME_TO_INFECT = 0 # The number of frames to wait until the infection is spread to connecting nodes. Use this to slow down the resulting animation. Set to -1 to disable.

LENGTH_OF_ACUTE = 3
ACUTE_TO_CHRONIC = 0.12
BETA_SUSCEPTIBLE = 0.25

DATA_OUTPUT = "/home/herb/Dropbox/School/Freshmen/Spring/Modeling-Biological-Systems/vaccines/sinatra/public/data/"

GRAPH_GENERATOR = "graph_generators/barabasi.r"

# Used for configuring the animation
#ANIMATION_OUTPUT = "/home/herb/Dropbox/School/Freshmen/Spring/Modeling-Biological-Systems/vaccines/sinatra/public/animation/"
ANIMATION_OUTPUT = "/home/herb/mbs-output/"
ANIMATION_FRAMES = 50
ANIMATION_OUTPUT_DATA = F

# Used for configuring data collection
SIMULATION_OUTPUT_DATA = F
SIMULATION_LENGTH = 50 # How long the simulation should run
SIMULATION_REPEAT = 50 # How many times to repeat the simulation

POWERS = 1#seq(0.0, 2.0, by = 0.5)
EDGES = seq(1, 2, by=1)
