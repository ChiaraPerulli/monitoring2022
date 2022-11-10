# install the package raster
install.packages("raster")

# recall the package
library(raster)

# set the working directory
setwd("C:/lab/")

# the brick function creates a rasterbrick (several layers with pixels)
brick("p224r63_2011_masked.grd") 

# assign the brick function to a certain name
p224r63_2011 <- brick("p224r63_2011_masked.grd") 



