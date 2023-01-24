# Species Distribution Modelling

# install.packages("sdm")
# install.packages("rgdal")

# Recall these packages
library(sdm)
library(rgdal)
library(raster)

# Use the function system.file to report the path to the data
file <- system.file("external/species.shp", package="sdm") 

# Use the shapefile function to read a shapefile  (raster package)
species <- shapefile(file)

# Plot the species
plot(species)   
species

# Let's take all the data that represent presences (1)
# First, have a look at the presence-absence
species$Occurrence

# Subset only the points meaning "presence"
presences <- species[species$Occurrence == 1,]
presences$Occurrence       # You will find just 1

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

# List the predictors
lst <- list.files(path=path, pattern='asc$', full.names = T)      # asc (extension) 
lst

# Use the stack function to aggregate the 4 files in lst
preds <- stack(lst)

# Plot the predictors
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)
preds

# MODEL
# Create sdm Data object
datasdm <- sdmData(train=species, predictors=preds)   # train data = points  # 
datasdm

# 4 dimensional model - 4 features
# ~ means = 
m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, data=datasdm, methods = "glm")  # glm is the simplest method = generalized linear model 
install.packages("parallel")

# Make the raster output layer
p1 <- predict(m1, newdata=preds)   # Predict the spread of the species based on the model

# Plot the output
plot(p1, col=cl)
points(species[species$Occurrence == 1,], pch=16)

# Add to the stack
s1 <- stack(preds,p1)
plot(s1, col=cl)
