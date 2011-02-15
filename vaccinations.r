# ---------------------------------- vaccinations.r --------------------------------- #
# 										      #
# This file includes all the functions that make up the model. 			      #
# 										      #
# timeStep is the most important function in here -- it modifies a graph based	      #	
# on the rules of the model.							      #
#										      #
# ----------------------------------------------------------------------------------- #

library(igraph)

timeStep <- function(population) {
	newgraph = add.edges(population, c()) # Make a copy of population
	
	# Find the infected individual
	for(i in V(population)) {
		# Increment the time that the individual has been in its current state
		time = get.vertex.attribute(newgraph, "time", index = i)
		newgraph = set.vertex.attribute(newgraph, "time", index = i, value = time + 1) 

		diseaseState = get.vertex.attribute(population, "disease", index = i)

		# Take different actions based on which state the individual is in
		if(diseaseState == "I") {

			# If the person is infected, but the infectious period is over then change the state to recovered
			if(time == LENGTH_OF_INFECTION) {
				newgraph = set.vertex.attribute(newgraph, "disease", index = i, value = "R") # Change the state from infected to recovered
				newgraph = set.vertex.attribute(newgraph, "time", index = i, value = 0) # Reset the time counter to 0
				V(newgraph)[i]$color = "blue" # Change the color to blue
			}
			else {
				if(time > TIME_TO_INFECT) {
					for(n in neighbors(population, i)) {
						# This node will have different effects on its neighbors depending on what state each of them is in.
						#
						# If the neighbor is vaccinated susceptible, than the disease has a chance of spreading.
						# If the neighbor is unvaccinated susceptible, then the disease is guarunteed to spread.
						#
						# If its neightbor is recovered, than the disease does not spread.

						if(V(population)[n]$vaccinated == "V") {
							# Have a 33% chance that the vaccinated individual will still catch the disease
							if(sample(c(1, 3), 1) == 1) {
								next
							}
						}

						# Skip this neighbor if they are recovered
						if(V(population)[n]$disease == "R") {
							next
						}

						# Spread to this neighbor if they are unvaccinated susceptible
						if(V(population)[n]$disease == "S") {
							V(newgraph)[n]$color = "red"
							newgraph = set.vertex.attribute(newgraph, "disease", index = n, value = "I")
							newgraph = set.vertex.attribute(newgraph, "time", index = n, value = 0)
						}
					}
				}
			}

			# Update the color
			infectionColors = heat.colors(10 * LENGTH_OF_INFECTION) # Multiply by 10 so we only get the redder colors
			V(newgraph)[i]$color = infectionColors[time + 1]

		}
		else if(diseaseState == "R") {
			V(newgraph)[i]$color = "blue"

			# If LENGTH_OF_RECOVERY is set to a negative number, than this functionality is disabled.
			if(LENGTH_OF_RECOVERY > 0) {

				# If we've reached the end of the recovery period, than the individual should go back to the susceptible state
				if(time == LENGTH_OF_RECOVERY) {
					newgraph = set.vertex.attribute(newgraph, "disease", index = i, value = "S") # Set the disease state back to S
					newgraph = set.vertex.attribute(newgraph, "time", index = i, value = 0) # Reset the time in current state attribute to 0
					V(newgraph)[i]$color = "white" 
				}

			}

		}

	}

	return(newgraph)
}

#
# Counts up the number of individuals in a particular disease state
#
# the paramater "state" should be either "S", "I", or "R"
#
inDiseaseState <- function(graph, state) {
	numState = 0
	for(i in V(graph)) {
		if(V(graph)[i]$disease == state) {
			numState = numState + 1
		}
	}
	return(numState)
}

#
# Returns whether or not all the individuals in the population are infected
#
allInfected <- function(graph) {
  for(i in V(graph)) {
    if(V(graph)[i]$disease == "S" || V(graph)[i] == "R") {
      return(F)
    }
  }
  return(T)
}

#
# A Wrapper for the plot function. 
# Plots a graph to the screen given a layout and what timestep the graph represents.
#
plotGraph <- function(graph, lay, t) {
	plot(graph, layout=lay, vertex.size = 3, vertex.label.dist = 1, vertex.label = paste(V(graph)$vaccinated), main=paste(c("Time: ", t)))
}
