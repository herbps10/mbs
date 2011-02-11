# General configuration
POPULATION_SIZE = 50
NUMBER_UNVACCINATED = 10 # The amount of people that start as being unvaccinated
NUMBER_INFECTIOUS = 4 # The amount of people that start as infectious
LENGTH_OF_INFECTION = 5
LENGTH_OF_RECOVERY = 1

TIME_TO_INFECT = -1 # The number of frames to wait until the infection is spread to connecting nodes. Use this to slow down the resulting animation. Set to -1 to disable.

# Used for configuring the animation
#ANIMATION_OUTPUT = "/home/herb/Dropbox/School/Freshmen/Spring/Modeling-Biological-Systems/vaccines/sinatra/public/animation/"
ANIMATION_OUTPUT = "/home/hps1/vaccines/sinatra/public/animation/"
ANIMATION_FRAMES = 100

# Used for configuring data collection
DATA_OUTPUT = "/home/hps1/vaccines/sinatra/public/data/"
SIMULATION_LENGTH = 50 # How long the simulation should run
SIMULATION_REPEAT = 10 # How many times to repeat the simulation
