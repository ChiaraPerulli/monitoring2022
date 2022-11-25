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

#### Threshold for trees
library(RStoolbox) # for classification

# unsupervised classification (the software is doing the threshold
d1c <- unsuperClass(l1992, nClasses=2)   # d1c = first classified image

# let's plot the d1c map
plot(d1c$map)

# 1992
# class 1: forest - 0.8977855
# class 2: human impact  - 0.1022145

# use dev.off to cancel the previous image organisation

# frequencies (to know the amount of pixels that have changed with time)
freq(d1c$map)
 value  count
[1,]     1 306407
[2,]     2  34885

# let's calculate the proportion of each class
# forest:
f1992 <- 306407 / (306407 + 34885)
[1] 0.8977855
# human impact:
h1992 <- 34885 / (306407 + 34885)
[1] 0.1022145

# let's do the classification for 2006
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

# let's create a table with our own data
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

# let's build a table with these data (with the function data.frame)
perc <- data.frame(landcover, percent_1992, percent_2006)

# lets' plot them for the final histogram!
# first of all, recall the library ggplot2
library(ggplot2)

# ggplot(name of the object, aes(x=x axis, y=y axis, color=color)) + geom_bar(stat="identity", fill="white")
# aes = aesthetics = explain how you want to build the histogram 
# histogram = geom_bar
ggplot(perc, aes(x=landcover, y=percent_1992, color=landcover)) + geom_bar(stat="identity", fill="orchid")

ggplot(perc, aes(x=landcover, y=percent_2006, color=landcover)) + geom_bar(stat="identity", fill="orchid")

# use the package patchwork to compose graphics without using the multiframe (it's more simple)
install.packages("patchwork")
library(patchwork)

# assign a ggplot to an object and then sum the objects
p1 <- ggplot(perc, aes(x=landcover, y=percent_1992, color=landcover)) + geom_bar(stat="identity", fill="orchid")
p2 <- ggplot(perc, aes(x=landcover, y=percent_2006, color=landcover)) + geom_bar(stat="identity", fill="orchid")

p1 + p2 

# let's put the first plot on top of the other
p1 / p2







