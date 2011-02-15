#install.packages("animation")
#install.packages("igraph")

library(igraph)

timeStep <- function(population) {
	newgraph = add.edges(population, c()) # Make a copy of population
	
	# Find the infected individual
	for(i in V(population)) {
		# Increment the time that the individual has been in its current state
		time = get.vertex.attribute(newgraph, "time", index = i)
		newgraph = set.vertex.attribute(newgraph, "time", index = i, value = time + 1) 

		diseaseState = get.vertex.attribute(population, "disease", index = i)


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
						if(V(population)[n]$vaccinated == "V") {
							# Have a 33% chance that the vaccinated individual will still catch the disease
							if(sample(c(1, 3), 1) == 1) {
								next
							}
						}

						if(V(population)[n]$disease == "R") {
							next
						}

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
			if(LENGTH_OF_RECOVERY > 0) {
				if(time == LENGTH_OF_RECOVERY) {
					newgraph = set.vertex.attribute(newgraph, "disease", index = i, value = "S")
					newgraph = set.vertex.attribute(newgraph, "time", index = i, value = 0)
					V(newgraph)[i]$color = "white"
				}
			}
		}

	}

	return(newgraph)
}

inDiseaseState <- function(graph, state) {
	numState = 0
	for(i in V(graph)) {
		if(V(graph)[i]$disease == state) {
			numState = numState + 1
		}
	}
	return(numState)
}

allInfected <- function(graph) {
  for(i in V(graph)) {
    if(V(graph)[i]$disease == "S") {
      return(F)
    }
  }
  return(T)
}

plotGraph <- function(graph, lay, t) {
	plot(graph, layout=lay, vertex.size = 3, vertex.label.dist = 1, vertex.label = paste(V(graph)$vaccinated), main=paste(c("Time: ", t)))
}
