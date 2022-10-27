# Point pattern analysis for population ecology 

# set the working directory
setwd("C:/lab/")

# use read.table to see the table
read.table("covid_agg.csv")

# name the object and add info about the headers
covid <- read.table("covid_agg.csv", header=T)

# to see the very first rows
head(covid)

# install the package spatstat (for spatial point pattern analysis)
install.packages("spatstat")

# to recall the package
library(spatstat)

# let's make a planar point pattern in spatstat (we have to explain the coordinates and the range of both the values -> arrays of elements)
## let's attach the covid dataset (or write x=covid$lon)
attach(covid)
ppp(x=lon, y=lat, c(-180,180), c(-90,90))

# assign a name to the ppp function
covid_planner <- ppp(x=lon, y=lat, c(-180,180), c(-90,90))

# let's plot it
plot(covid_planner)

# let's make a density map with the function density
density_map <- density(covid_planner)

# plot the density map and add the original points with the function points
plot(density_map)
points(covid_planner)

# change the points
points(covid_planner, pch=19)

# change the colours with the function colorRampPalette
cl <- colorRampPalette(c("cyan","coral","chartreuse"))(100)     # 100 is the amount of tones

# plot the new map, with the argument col=cl
plot(density_map, col = cl)

# add the points
points(covid_planner, pch=17, col="blue")

# exercise
# change the colours

ex <- colorRampPalette(c("darkslategray3","coral","deepskyblue4"))(100)
plot(density_map, col=ex)
points(covid_planner, pch=19, col="cyan")
