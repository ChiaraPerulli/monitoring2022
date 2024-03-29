# Calculating vegetation indices from remote sensing

# Recall the package raster
library(raster)

# Set the working directory
setwd("C:/lab/")

# Use the brick function to import the data 
l1992 <- brick("defor1.png")

# Bands: 1 NIR, 2 RED, 3 GREEN (vegetation will become red)
plotRGB(l1992, r=1, g=2, b=3, stretch="lin")

# Let's do the same with the second picture
l2006 <- brick("defor2.png")
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# Let's make a multiframe
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

#### Threshold for trees
library(RStoolbox)  # for classification

# Unsupervised classification (the software is doing the threshold)
d1c <- unsuperClass(l1992, nClasses=2)   # d1c = first classified image

# Let's plot the d1c map
plot(d1c$map)

# 1992
# class 1: forest - 0.8977855
# class 2: human impact  - 0.1022145

# Use dev.off to cancel the previous image organisation

# Frequencies (to know the amount of pixels that have changed with time)
freq(d1c$map)
 value  count
[1,]     1 306407
[2,]     2  34885

# Let's calculate the proportion of each class
# forest:
f1992 <- 306407 / (306407 + 34885)
[1] 0.8977855
# human impact:
h1992 <- 34885 / (306407 + 34885)
[1] 0.1022145

# Let's do the classification for 2006
d2c <- unsuperClass(l2006, nClasses=2)
plot(d2c$map)
freq(d2c$map)
     value  count
[1,]     1 164613
[2,]     2 178113

# 2006 
# class 1: human impact  - 0.480305   # the classes have changed
# class 2: forest - 0.519695  

# forest:
f2006 <- 178113 / (178113 + 164613)
[1] 0.519695
# human impact: 
h2006 <- 164613 / (178113 + 164613)
[1] 0.480305

# Let's create a table with our own data
data.frame

# 1992 vs 2006

# 1992
# forest : 0.8977855
# human impact  : 0.1022145

# 2006
# forest : 0.519695
# human impact : 0.480305  

landcover <- c("Forest", "Humans")
percent_1992 <- c(89.78, 10.22)   # use the point as the decimal separator
percent_2006 <- c(51.97, 48.03)

# Let's build a table with these data (with the function data.frame)
perc <- data.frame(landcover, percent_1992, percent_2006)

# Lets' plot them for the final histogram!
# First of all, recall the library ggplot2
library(ggplot2)

# ggplot(name of the object, aes(x=x axis, y=y axis, color=color)) + geom_bar(stat="identity", fill="white")
# aes = aesthetics = explain how you want to build the histogram 
# histogram = geom_bar
ggplot(perc, aes(x=landcover, y=percent_1992, color=landcover)) + geom_bar(stat="identity", fill="orchid")

ggplot(perc, aes(x=landcover, y=percent_2006, color=landcover)) + geom_bar(stat="identity", fill="orchid")

# Use the package patchwork to compose graphics without using the multiframe (it's more simple)
install.packages("patchwork")
library(patchwork)

# Assign a ggplot to an object and then sum the objects
p1 <- ggplot(perc, aes(x=landcover, y=percent_1992, color=landcover)) + geom_bar(stat="identity", fill="orchid")
p2 <- ggplot(perc, aes(x=landcover, y=percent_2006, color=landcover)) + geom_bar(stat="identity", fill="orchid")

p1 + p2 

# Let's put the first plot on top of the other
p1 / p2

###### ggplot examples
# rgb
library(raster)
library(RStoolbox)

setwd("C:/lab/")

l1992 <- brick("defor1.png")

plotRGB(l1992, r=1, g=2, b=3, stretch="lin")

ggRGB(l1992, 1, 2, 3)  # same result, but more simple! 

# You can plot also single layers
dvi1992= l1992[[1]] - l1992[[2]]
plot(dvi1992)

ggplot() + geom_raster(dvi1992, mapping= aes(x=x, y=y, fill=layer))      # fill = name of the layer you want to use

# install.packages("viridis")
library(viridis)

ggplot() + geom_raster(dvi1992, mapping= aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="magma") 

# The function scale_fill_viridis gives lots of options (viridis, magma, heat, plasma, mako, ... )
# With this function, everyone can see the different colours!

# Exercise: with the patchwork package, put 2 graphs one besides the other with two different viridis color ramps
library(patchwork)
g1 <- ggplot() + geom_raster(dvi1992, mapping= aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="mako") 
g2 <- ggplot() + geom_raster(dvi1992, mapping= aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="plasma") 

g1 + g2
