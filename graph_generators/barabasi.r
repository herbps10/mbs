initGraph <- function() {
	g <- barabasi.game(POPULATION_SIZE, 1, directed = F)
	g <- set.vertex.attribute(g, "vaccinated", value="V")
	g <- set.vertex.attribute(g, "disease", value="S")
	g <- set.vertex.attribute(g, "time", value=0)

	V(g)$color <- "white"

	unvaccinated = sample(1:length(V(g))-1, NUMBER_UNVACCINATED)

	for(i in unvaccinated) {
		g <- set.vertex.attribute(g, "vaccinated", index = i, value="U")
	}

	initial_infected = sample(1:length(V(g))-1, NUMBER_INFECTIOUS)
	for(i in initial_infected) {
		g <- set.vertex.attribute(g, "disease", index = i, value = "I")
		g <- set.vertex.attribute(g, "time", index = i, value=0)

		V(g)[i]$color <- "red"
	}

	return(g)
}
