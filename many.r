# --------------------------- many.r ---------------------------- #
# 								  #
# This file will run multiple simulations. 		   	  #
# It can only output a master data file for all the simulations.  #
#							   	  #
# --------------------------------------------------------------- #

source("parameters.r")
source("vaccinations.r")
source(GRAPH_GENERATOR)

#dataPath = paste(c(DATA_OUTPUT, "output.dat"), sep="", collapse="")

# Output the table header to the file
#cat("\tS\tI\tR\n", file=dataPath)
# Write the model parameters to the bottom of the file
write.table(c(
		"",
		POPULATION_SIZE,
		NUMBER_VACCINATED,
		NUMBER_INFECTIOUS,
		LENGTH_OF_ACUTE,
		ACUTE_TO_CHRONIC,
		BETA_SUSCEPTIBLE,
		SIMULATION_REPEAT,
		""
	),
	"averages.csv",
	col.names = F,
	sep = ";",
	row.names = c(
		"Model Parameters",
		"Population Size",
		"Vaccinated",
		"Infectious",
		"Length of Acute",
		"Acute to Chronic",
		"Beta Susceptible",
		"Simulation Repeat",
		""
	)
)

counter = 0
for(power in POWERS) {
	for(edge in EDGES) {
		all.max.infected = c()
		all.max.infected.percentage = c()

		all.end.susceptible = c()
		all.end.susceptible.percentage = c()

		all.max.change = c()
		all.time.of.max.change = c()

		all.mean.rnot = c()

		all.mean.delta.rnot = c()

		all.frame = c() # Time to all infected

		for(simulation in c(1:SIMULATION_REPEAT)) {
			g = initGraph(power, edge)
			susceptible = c()
			infectious = c() # This holds the sum of acute and chronicly infected individuals
			acute = c()
			chronic = c()
			immune = c()

			# change in susceptible and change in infectious
			dS = c()
			dI = c()

			frame = 0

			# We can tell if the simulation isn't changing if the change in infected people equals zero. 
			# That means that no new people are becoming infected.
			# If there is no change over five timesteps, stop the simulation.
			# To figure this out, add up the last ten dI values. If they equal zero,
			# Then nothing has changed.
			# Keep running the simulation while there has been any change over the last ten timesteps.
			# Make sure that the simulation runs for at least five timesteps.
			while(length(dI) <= 5 || sum(tail(dI ^ 2, 10)) != 0) {
				# Count the number in each state and output to the table

				# Update the state vectors
				susceptible = append(susceptible, inDiseaseState(g, "SUSCEPTIBLE"))
				acute = append(acute, inDiseaseState(g, "ACUTE"))
				chronic = append(chronic, inDiseaseState(g, "CHRONIC"))
				immune = append(immune, inDiseaseState(g, "IMMUNE"))

				# Add the number of acute and chronic to get the total number of people infected
				# the tail function gets the last element of a vector
				infectious = append(infectious, tail(acute, 1) + tail(chronic, 1))

				infectious.vertices = append(V(g)[V(g)$state == "CHRONIC"], V(g)[V(g)$state == "ACUTE"])
				mean.rnot = mean(V(g)[infectious.vertices]$RNot)
				all.mean.rnot = append(all.mean.rnot, mean.rnot)

				mean.delta.rnot = mean(V(g)[infectious.vertices]$localRNot)
				all.mean.delta.rnot = append(all.mean.delta.rnot, mean.delta.rnot)

				# Infectious vertices

				# Update change vectors
				dS = append(dS, susceptible[frame] - susceptible[frame - 1])
				dI = append(dI, infectious[frame] - infectious[frame - 1])

				# Output the current timestep to the screen
				cat(tail(infectious, 1), " ", frame, "\n")

				########################
				# Update the actual model
				#########################
				g = timeStep(g)
				frame = frame + 1

				matplot(data.frame(susceptible, infectious, immune), col=c("black", "red", "green"), type="l", lty=1, lwd=3)
			}

			all.frame = append(all.frame, frame)

			data.frame = data.frame(susceptible, acute, chronic, immune, infectious)
			# Maximum percentage infected
			max.infected = max(data.frame$infectious)
			max.infected.percentage = max.infected/POPULATION_SIZE * 100

			end.susceptible = max(tail(data.frame$susceptible, 1))
			end.susceptible.percentage = end.susceptible/POPULATION_SIZE * 100

			# Keep a list of all the values so we can average them later
			all.max.infected = append(all.max.infected, max.infected)
			all.max.infected.percentage = append(all.max.infected.percentage, max.infected.percentage)

			all.end.susceptible = append(all.end.susceptible, end.susceptible)
			all.end.susceptible.percentage = append(all.end.susceptible.percentage, end.susceptible.percentage)

			#par(mfrow = c(1, 2))
			#plot(y = data.frame$S, x=1:SIMULATION_LENGTH)
			#plot(y = data.frame$I, x=1:SIMULATION_LENGTH, col="red")

			data.change = data.frame(dS, dI)

			# Return the max change in infectious
			max.change = max(data.change$dI)

			# Return the time step of the first peak change value. 
			time.of.max.change = head(seq(along=data.change$dI)[data.change$dI == max.change], 1)

			all.max.change = append(all.max.change, max.change)
			all.time.of.max.change = append(all.time.of.max.change, time.of.max.change)

			cat("Max Change", max.change, "\n")
			cat("Time of max change: ", time.of.max.change, "\n")
		}

		avg.max.infected = sum(all.max.infected) / SIMULATION_REPEAT
		avg.max.infected.percentage = sum(all.max.infected.percentage) / SIMULATION_REPEAT
		avg.frame = sum(all.frame) / SIMULATION_REPEAT
		avg.end.susceptible.percentage = sum(all.end.susceptible.percentage) / SIMULATION_REPEAT
		avg.time.of.max.change = sum(all.time.of.max.change) / SIMULATION_REPEAT
		avg.max.change = sum(all.max.change) / SIMULATION_REPEAT


		write.table(c(
				"",
				power,
				edge,
				"",
				"",
				avg.max.infected,
				avg.max.infected.percentage,
				avg.frame,
				avg.end.susceptible.percentage,
				avg.time.of.max.change,
				avg.max.change,
				counter,
				""
			),
			"averages.csv", 
			row.names = c(
				"Barabasi Parameters",
				"Power",
				"Edges",
				"",
				"Averages",
				"Max Infected",
				"Max Infected Percentage",
				"Frame",
				"End Susceptible Percentage",
				"Time of Max Change",
				"Max Change",
				"Counter",
				""
			),
			col.names=F, 
			sep=";",
			append = T
		)

		counter = counter + 1
	}
}


