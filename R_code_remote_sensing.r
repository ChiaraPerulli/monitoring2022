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

# we can plot the single bands (each band shows the amount of reflectance in a certain wavelenght)
plot(p224r63_2011)

# we can change the colour of the bands with the function colorRampPalette
cl <- colorRampPalette(c('black','grey','light grey'))(100) # 100 is the amount of different tones 

# replot with the new colour palette
plot(p224r63_2011, col=cl)

# 


