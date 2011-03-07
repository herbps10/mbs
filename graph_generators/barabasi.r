initGraph <- function(p, e) {
	g <- barabasi.game(POPULATION_SIZE, power=p, m = e, directed = F)
	g <- set.vertex.attribute(g, "state", value = "SUSCEPTIBLE")
	g <- set.vertex.attribute(g, "time", value = 0)

	g <- set.vertex.attribute(g, "localRNot", value = 0)
	g <- set.vertex.attribute(g, "RNot", value = 0)

	V(g)$color <- "white"

	vaccinated = sample(1:length(V(g))-1, NUMBER_VACCINATED)

	for(i in vaccinated) {
		g <- set.vertex.attribute(g, "state", index = i, value="IMMUNE")
	}

	initial_infected = sample(1:length(V(g))-1, NUMBER_INFECTIOUS)
	for(i in initial_infected) {
		g <- set.vertex.attribute(g, "state", index = i, value = "CHRONIC")

		g <- set.vertex.attribute(g, "time", index = i, value=0)

		V(g)[i]$color <- "red"
	}

	return(g)
}
