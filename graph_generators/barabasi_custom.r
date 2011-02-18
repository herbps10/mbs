initGraph <- function() {
	g = barabasi.game(1000, directed = F)
	#g = erdos.renyi.game(1000, 0.75);

	g <- set.vertex.attribute(g, "vaccinated", value = "V")
	g <- set.vertex.attribute(g, "disease", value = "S")
	g <- set.vertex.attribute(g, "time", value = 0)

	V(g)$color <- "white"

	for(i in seq(1:10)) {
	  max = which(degree(g) == max(degree(g))) - 1
	  g = delete.vertices(g, max)
	}

	g_clusters = clusters(g)

	newgraph = add.edges(g, c())
	to_delete = c()
	for(i in which(g_clusters$csize < 15)) {
		to_delete = append(to_delete, which(g_clusters$membership == (i - 1)) - 1)
	}
	newgraph = delete.vertices(newgraph, to_delete)

	# Add a few edges in each component
	to_add = c()
	new_clusters = clusters(newgraph)
	for(i in 0:(new_clusters$no - 1)) {
		# Connect some nodes within this component to create a more connected community.le.to.membership
		for(n in 0:20) {
			# Picks two node IDs from the current cluster
			nodes = sample(which(new_clusters$membership == i) - 1, 2, replace=F)
			  
			to_add = append(to_add, nodes)
		}
	}

	# Pick one cluster to unvaccinate
	cluster_to_unvaccinate = sample(0:new_clusters$no - 1, 1)
	for(node in which(new_clusters$membership == cluster_to_unvaccinate) - 1) {
		newgraph <- set.vertex.attribute(newgraph, "vaccinated", index = node, value = "U")
	}

	newgraph = add.edges(newgraph, to_add)

	# connect each component until there is only one large component
	while(clusters(newgraph)$no != 1) {
	  new_clusters = clusters(newgraph)
	  to_add = c()
	  for(i in 0:(new_clusters$no - 1)) {
		  # Connect some nodes within this component to create a more connected community.le.to.membership
		  for(n in 0:10) {
		    nodes = sample(which(new_clusters$membership == i) - 1, 2, replace=F)
			  
		    to_add = append(to_add, nodes)
		  }
		  
		  # Connect the this component to another component
		  node1 = sample(which(new_clusters$membership == i) - 1, 1)
		  node2 = sample(which(new_clusters$membership != i) - 1, 1)
		  
		  to_add = append(to_add, c(node1, node2))
	  }

	  newgraph = add.edges(newgraph, to_add)
	}

	# Set up initial unvaccinated
	#unvaccinated = sample(1:length(V(newgraph))-1, NUMBER_UNVACCINATED)
	#for(i in unvaccinated) {
		#newgraph <- set.vertex.attribute(newgraph, "vaccinated", index = i, value = "U")
	#}

	# Set up initial infected
	initial_infected = sample(1:length(V(newgraph))-1, NUMBER_INFECTIOUS)
	for(i in initial_infected) {
		newgraph <- set.vertex.attribute(newgraph, "disease", index = i, value = "I")
		newgraph <- set.vertex.attribute(newgraph, "time", index = i, value = 0)

		V(g)[i]$color <- "red"
	}

	#plot(newgraph, layout = layout.fruchterman.reingold, vertex.size = 1, vertex.label.dist = 0.5, vertex.label.cex = 0.5, vertex.label="")

	return(newgraph)
}
