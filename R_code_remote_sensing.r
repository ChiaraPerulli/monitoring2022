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

# Let's plot just one band (the first band is the blue band)
## First solution
plot(p224r63_2011$B1_sre, col=cl)   
## Second solution
plot(p224r63_2011[[1]], col=cl)  # this way you don't have to remember the name of the element

##### Exercise: change the colour ramp palette with colours from dark blue to light blue
blue <- colorRampPalette(c("darkblue","blue3","blue"))(100)
plot(p224r63_2011, col=blue)

# With the function par we can build multiframe of different images
par(mfrow=c(1,2))  # 1 row and 2 columns # these elements belong to the same array

# Now we can plot the elements inside the multiframe 
plot(p224r63_2011[[1]], col=cl)
plot(p224r63_2011[[2]], col=cl)

##### Exercise: create a multiframe with 4 images (2x2)
par(mfrow=c(2,2))
plot(p224r63_2011[[1]], col=cl)
plot(p224r63_2011[[2]], col=cl)
plot(p224r63_2011[[3]], col=cl)
plot(p224r63_2011[[4]], col=cl)








