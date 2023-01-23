# Point pattern analysis for population ecology 

# Set the working directory
setwd("C:/lab/")

# Use read.table to see the table
read.table("covid_agg.csv")

# Name the object and add info about the headers
covid <- read.table("covid_agg.csv", header=T)

# To see the very first rows
head(covid)

# Install the package spatstat (for spatial point pattern analysis)
install.packages("spatstat")

# To recall the package
library(spatstat)

# Let's make a planar point pattern in spatstat (we have to explain the coordinates and the range of both the values -> arrays of elements)
## Let's attach the covid dataset (or write x=covid$lon)
attach(covid)
ppp(x=lon, y=lat, c(-180,180), c(-90,90))

# Assign a name to the ppp function
covid_planar <- ppp(x=lon, y=lat, c(-180,180), c(-90,90))

# Let's plot it
plot(covid_planar)

# Let's make a density map with the function density
density_map <- density(covid_planar)

# Plot the density map and add the original points with the function points
plot(density_map)
points(covid_planar)

# Change the points
points(covid_planar, pch=19)

# Change the colours with the function colorRampPalette
cl <- colorRampPalette(c("cyan","coral","chartreuse"))(100)     # 100 is the amount of tones

# Plot the new map, with the argument col=cl
plot(density_map, col = cl)

# Add the points
points(covid_planar, pch=17, col="blue")

# Exercise
# Change the colours

ex <- colorRampPalette(c("darkslategray3","coral","deepskyblue4"))(100)
plot(density_map, col=ex)
points(covid_planar, pch=19, col="cyan")

# Install the package rgdal
install.packages("rgdal")

# We need these libraries
library(spatstat)
library(rgdal)

# Set the working directory
setwd("C:/lab/")

# Let's add the coastlines!
## Use the function readOGR (for vector maps)
coastlines <- readOGR("ne_10m_coastline.shp")

covid <- read.table("covid_agg.csv", header=T)
head(covid)
attach(covid)
ppp(x=lon, y=lat, c(-180,180), c(-90,90))
covid_planar <- ppp(x=lon, y=lat, c(-180,180), c(-90,90))
plot(covid_planar)
plot(coastlines, add=T)   # the argument add=T is necessary

# Add the density 
density_map <- density(covid_planar)
plot(density_map)

# Add the points to the previous graph
points(covid_planar, pch=18, col="royalblue4") 

# Add the coastlines
plot(coastlines, add= T, col="blue")

# Change the colour palette
cl <- colorRampPalette(c("cyan","purple3","orchid3"))(100)
plot(density_map, col=cl)

# Use the function marks to interpolate 
## Explain what variable needs to be interpolated (abundance)
attach(covid)
marks(covid_planar) <- cases  # cases is the variable to interpolate

# Use the Smooth function to build the final map
cases_map <- Smooth(covid_planar)

# Plot the map
plot(cases_map, col=cl)

# Plot the points 
points(covid_planar)

# Plot the coastlines
plot(coastlines, add=T)
