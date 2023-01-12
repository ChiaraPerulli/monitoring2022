# Species Distribution Modelling

# install.packages("sdm")
# install.packages("rgdal")

library(sdm)
library(rgdal)
library(raster)

# Use the function system.file to report the path to the data
file <- system.file("external/species.shp", package="sdm") 

# Use the shapefile function to read a shapefile  (raster package)
species <- shapefile(file)

# plot the species
plot(species)   
species

# Let's take all the data that represent presences (1)
# First, have a look at the presence-absence
species$Occurrence

# Subset only the points meaning "presence"
presences <- species[species$Occurrence == 1,]
presences$Occurrence                   # You will find just 1

# Exercise: select the absences
species$Occurrence
absences <- species[species$Occurrence == 0,]
absences$Occurrence

# Plot the presences
plot(presences, col = "green", pch = 9)

# Plot the absences (do not use the plot function)
points(absences, col = "red", pch = 8)

# Predictors = environmental variables that help us to predict the distribution of the species
# Look at the path
path <- system.file("external", package="sdm")    # Explain what is the folder where R can find the predictors
path 

# list the predictors
lst <- list.files(path=path, pattern='asc$', full.names = T)      # asc (extension) 
lst

# Use the stack function to aggregate the 4 files in lst
preds <- stack(lst)

# plot the predictors
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)
preds

# plot predictors and occurrences
plot(preds$elevation, col=cl)
points(species[species$Occurrence == 1,], pch=16)

plot(preds$temperature, col=cl)
points(species[species$Occurrence == 1,], pch=16)

plot(preds$precipitation, col=cl)
points(species[species$Occurrence == 1,], pch=16)

plot(preds$vegetation, col=cl)
points(species[species$Occurrence == 1,], pch=16)








