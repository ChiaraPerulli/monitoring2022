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

# With the function par we can build a multiframe of different images (several plots all together)
par(mfrow=c(1,2))  # 1 row and 2 columns # these elements belong to the same array

# Now we can plot the single elements inside the multiframe 
plot(p224r63_2011[[1]], col=cl)
plot(p224r63_2011[[2]], col=cl)

##### Exercise: create a multiframe with 4 images (2x2)
par(mfrow=c(2,2))
plot(p224r63_2011[[1]], col=cl)
plot(p224r63_2011[[2]], col=cl)
plot(p224r63_2011[[3]], col=cl)
plot(p224r63_2011[[4]], col=cl)

##### Exercise: plot the four bands with different legends (colour ramps)
par(mfrow=c(2,2))
blue <- colorRampPalette(c("darkblue","blue3","blue"))(100)  
plot(p224r63_2011[[1]], col=blue)
green <- colorRampPalette(c("dark green","green","light green"))(100)
plot(p224r63_2011[[2]], col=green)
red <- colorRampPalette(c("brown3","red","brown1"))(100)  
plot(p224r63_2011[[3]], col=red)
infrared <- colorRampPalette(c("darkorchid4","darkorchid2","darkorchid"))(100)  # this band is the nearinfrared band
plot(p224r63_2011[[4]], col=infrared)

# plotRGB is a function that we can use to superimpose bands and create a new image. It uses the red, green and blue band to plot a raster object. 
# multilayared coloursp
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="lin")  
# first of all, put the name of the object, then explain the correspondance component-band. 
# stretch is used to increase the contrast of the image

# before plotting, close the previous window with 
dev.off()

# Now you can see the natural colours of the forest!!

# We will move up the bands and remove the first one in order to consider the nearinfrared band (useful to recognize plants). We expect that vegetation will become RED (because we replaced the red with the nearinfrared).
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="lin")  

# We will invert green and red (this way you see the vegetation green). 
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="lin")  

# We will invert green and blue (vegetation will become blue). This is useful to recognize bare soil (yellow). 
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="lin")  


##### Exercise: plot the previous 4 manners in a single multiframe
par(mfrow=c(2,2))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="lin")  
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="lin") 
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="lin")  
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="lin")  

# let's see an histogram stretching (we are stretching the values a lot) on one band
par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="lin") # linear stretching
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="hist") # histogram stretching # you can see clearer, both vegetation and  bare soil

# 





