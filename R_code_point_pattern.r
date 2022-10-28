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
covid_planar <- ppp(x=lon, y=lat, c(-180,180), c(-90,90))

# let's plot it
plot(covid_planar)

# let's make a density map with the function density
density_map <- density(covid_planar)

# plot the density map and add the original points with the function points
plot(density_map)
points(covid_planar)

# change the points
points(covid_planar, pch=19)

# change the colours with the function colorRampPalette
cl <- colorRampPalette(c("cyan","coral","chartreuse"))(100)     # 100 is the amount of tones

# plot the new map, with the argument col=cl
plot(density_map, col = cl)

# add the points
points(covid_planar, pch=17, col="blue")

# exercise
# change the colours

ex <- colorRampPalette(c("darkslategray3","coral","deepskyblue4"))(100)
plot(density_map, col=ex)
points(covid_planar, pch=19, col="cyan")

# install the package rgdal
install.packages("rgdal")

# we need these libraries
library(spatstat)
library(rgdal)

# set the working directory
setwd("C:/lab/")

# let's add the coastlines!
## use the function readOGR (for vector maps)
coastlines <- readOGR("ne_10m_coastline.shp")

covid <- read.table("covid_agg.csv", header=T)
head(covid)
attach(covid)
ppp(x=lon, y=lat, c(-180,180), c(-90,90))
covid_planar <- ppp(x=lon, y=lat, c(-180,180), c(-90,90))
plot(covid_planar)
plot(coastlines, add=T)   # the argument add=T is necessary

# add the density 
density_map <- density(covid_planar)
plot(density_map)

# add the points to the previous graph
points(covid_planar, pch=18, col="royalblue4") 

# add the coastlines
plot(coastlines, add= T, col="blue")

# change the colour palette
cl <- colorRampPalette(c("cyan","purple3","orchid3"))(100)
plot(density_map, col=cl)

# use the function marks to interpolate 
## explain what variable needs to be interpolated (abundance)
attach(covid)
marks(covid_planar) <- cases # cases is the variable to interpolate

# use the Smooth function to build the final map
cases_map <- Smooth(covid_planar)

# plot the map
plot(cases_map, col=cl)

# plot the points 
points(covid_planar)

# plot the coastlines
plot(coastlines, add=T)


