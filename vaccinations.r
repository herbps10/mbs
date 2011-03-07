# ---------------------------------- vaccinations.r --------------------------------- #
# 										      #
# This file includes all the functions that make up the model. 			      #
# 										      #
# timeStep is the most important function in here -- it modifies a graph based	      #	
# on the rules of the model.							      #
#										      #
# ----------------------------------------------------------------------------------- #

library(igraph)

# Sets the compartmental state to a given index
setState <- function(graph, i, state) {
	return(set.vertex.attribute(graph, "state", index = i, value = state))
}

# Resets the time of a vertex
resetTime <- function(graph, i) {
	return(set.vertex.attribute(graph, "time", index = i, value = 0))
}

resetRNot <- function(graph, i) {
	return(set.vertex.attribute(graph, "RNot", index = i, value = 0))
}

incrementRNot <- function(graph, amount, i) {
	RNot = get.vertex.attribute(graph, "RNot", index = i)

	graph = set.vertex.attribute(graph, "localRNot", index = i, value = amount)

	RNot = RNot + amount
	graph = set.vertex.attribute(graph, "RNot", index = i, value = RNot)

	return(graph)
}

# Sets vertex number i to given color
setColor <- function(graph, i, color) {
	V(graph)[i]$color = color;

	return(graph)
}

# Move vertex number i to the immune state
setImmune <- function(graph, i) {
	graph = setState(graph, i, "IMMUNE")
	graph = resetTime(graph, i)
	graph = setColor(graph, i, "green")

	return(graph)
}

# Move vertex number i to acute state
setAcute <- function(graph, i) {
	graph = setState(graph, i, "ACUTE")
	graph = resetTime(graph, i)
	graph = setColor(graph, i, "red")

	return(graph)
}

# Move vertex i to acute state
setChronic <- function(graph, i) {
	graph = setState(graph, i, "CHRONIC")
	graph = resetTime(graph, i)
	graph = setColor(graph, i, "red")

	return(graph)
}

timeStep <- function(population) {
	graph = add.edges(population, c()) # Make a copy of population

	V(graph)$localRNot = 0
	
	# Find the infected individual
	for(i in V(population)) {
		# Increment the time that the individual has been in its current state
		time = get.vertex.attribute(graph, "time", index = i)
		graph = set.vertex.attribute(graph, "time", index = i, value = time + 1) 

		state = get.vertex.attribute(population, "state", index = i)

		# Take different actions based on which state the individual is in
		if(state == "ACUTE") {
			# If the individual has been acutely infected for a given time, they transition to the 
			if(time == LENGTH_OF_ACUTE) {
				if(runif(1) < ACUTE_TO_CHRONIC) {
					graph = setChronic(graph, i)
				}
				else {
					graph = setImmune(graph, i)
				}
			}
		}

		if(state == "CHRONIC" || state == "ACUTE") {
		      # Get the susceptible neighbors
		      allNeighbors = neighbors(population, i)
		      susceptibleNeighbors = allNeighbors[V(g)[allNeighbors]$state == "SUSCEPTIBLE"]
		      toInfect = susceptibleNeighbors[runif(length(susceptibleNeighbors)) < BETA_SUSCEPTIBLE]
			
		      graph = incrementRNot(graph, length(toInfect), i)
		      
		      for(n in toInfect) {
			graph = setAcute(graph, n)
		      }
		}
	}

	return(graph)
}

#
# Counts up the number of individuals in a particular disease state
#
# the paramater "state" should be either "S", "I", or "R"
#
inDiseaseState <- function(graph, state) {
	numState = 0
	for(i in V(graph)) {
		if(V(graph)[i]$state == state) {
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
    if(V(graph)[i]$state == "SUSCEPTIBLE" || V(graph)[i]$state == "IMMUNE") {
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
	plot(graph, layout=lay, vertex.size = 3, vertex.label.dist = 0.5, vertex.label = paste(substr(V(graph)$state, 0, 1), V(graph)$RNot), main=paste(c("Time: ", t)))
}

RNotGraph <- function(graph) {
	h = add.edges(graph, c())
	lay = layout.fruchterman.reingold(h)

	heatColors = rev(heat.colors(max(V(h)$RNot) + 1))

	counter = 1
	for(v in V(h)) {
		if(V(h)[v]$RNot == 0) {
			V(h)[v]$color = "white"
		}
		else {
			V(h)[v]$color = heatColors[V(h)[v]$RNot + 1]
		}
	}

	plot(h, layout=lay, vertex.size = (V(h)$RNot / 2) + 3, vertex.label="", vertex.label.dist=0.5)
}

avgRNot <- function(graph) {
	
}
