source("/home/herb/Dropbox/School/Freshmen/Spring/Modeling-Biological-Systems/vaccines/vaccinations.r")
source("/home/herb/Dropbox/School/Freshmen/Spring/Modeling-Biological-Systems/vaccines/parameters.r")

# This will overwrite the default parameters with command line arguments
source("/home/herb/Dropbox/School/Freshmen/Spring/Modeling-Biological-Systems/vaccines/getopt.r")

library(animation)

g = initGraph()

lay = layout.fruchterman.reingold(g)
par(mfrow = c(1, 1))
oopt = ani.options(interval = 0.1, outdir = ANIMATION_OUTPUT, ani.width=1000, ani.height = 800)
ani.start()

plotGraph(g, lay, 0)

for(n in c(1:ANIMATION_FRAMES)) {
	g = timeStep(g)
	plotGraph(g, lay, n)
}

ani.stop()
ani.options(oopt)
