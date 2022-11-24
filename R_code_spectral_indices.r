# Calculating vegetation indices from remote sensing

# recall the package raster
library(raster)

# set the working directory
setwd("C:/lab/")

# use the brick function to import the data 
l1992 <- brick("defor1.png")

# bands: 1 NIR, 2 RED, 3 GREEN (vegetation will become red)
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")

# let's do the same with the second picture
l2006 <- brick("defor2.png")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# let's make a multiframe
par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# DVI Difference Vegetation Index for 1992
dvi1992 <- l1992[[1]] - l1992[[2]]

cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100) 
plot(dvi1992, col=cl)

# DVI Difference Vegetation Index for 2006
dvi2006 = l2006[[1]] - l2006[[2]]
plot(dvi2006, col=cl)

# The yellow parts have low amount of vegetation. There is a huge amount of vegetation loss. 










