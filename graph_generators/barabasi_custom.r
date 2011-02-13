library(igraph)

g = barabasi.game(1000, directed = F)
#g = erdos.renyi.game(1000, 0.75);

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
	    nodes = sample(which(new_clusters$membership == i) - 1, 2, replace=F)
	  	  
	    to_add = append(to_add, nodes)
	  }
}

newgraph = add.edges(newgraph, to_add)

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

#while(clusters(newgraph)$no > 1) {
#  for(i in sample(V(newgraph), 1, replace = F)) {
#    for(j in sample(V(newgraph), 1, replace = F)) {
#      if(i == j) {
#	next
#      }

#      newgraph = add.edges(newgraph, c(i, j))
#    }
#  }
#}

#X11(width=7, height=7)
plot(newgraph, layout = layout.fruchterman.reingold, vertex.size = 1, vertex.label.dist = 0.5, vertex.label.cex = 0.5, vertex.label="")