# --------------------------- many.r ---------------------------- #
# 								  #
# This file will run multiple simulations. 		   	  #
# It can only output a master data file for all the simulations.  #
#							   	  #
# --------------------------------------------------------------- #

source("parameters.r")
source("vaccinations.r")
source(GRAPH_GENERATOR)

# Truncate the data file
write.table(
	matrix(c("counter", "POPULATION_SIZE", "NUMBER_VACCINATED", "NUMBER_INFECTIOUS", "LENGTH_OF_ACUTE", "ACUTE_TO_CHRONIC", "BETA_SUSCEPTIBLE", "power", "edge", "VACCINATION_STRATEGY", "VACCINATION_TIME", "max.infected", "time.of.max.infected", "end.susceptible", "max.change", "time.of.max.change", "frame"), ncol=17),
	"averages.csv", append=F, col.names = F)

counter = 0
for(power in POWERS) {
	for(edge in EDGES) {
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

			data.change = data.frame(dS, dI)

			# Return the max change in infectious
			max.change = max(data.change$dI)

			# Return the time step of the first peak change value. 
			time.of.max.change = head(seq(along=data.change$dI)[data.change$dI == max.change], 1)

			time.of.max.infected = -1

			write.table(
				matrix(c(counter, POPULATION_SIZE, NUMBER_VACCINATED, NUMBER_INFECTIOUS, LENGTH_OF_ACUTE, ACUTE_TO_CHRONIC, BETA_SUSCEPTIBLE, power, edge, VACCINATION_STRATEGY, VACCINATION_TIME, max.infected, time.of.max.infected, end.susceptible, max.change, time.of.max.change, frame), ncol=17),
				"averages.csv", col.names=F, append = T);

			cat("Max Change", max.change, "\n")
			cat("Time of max change: ", time.of.max.change, "\n")
		}

		counter = counter + 1
	}
}
