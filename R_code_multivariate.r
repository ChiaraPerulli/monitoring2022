# Community ecology example with R
## Multivariate analysis 

# install the package vegan, a famous community ecology package
install.packages("vegan")
library(vegan)  

# set the working directory
setwd("C:/lab/")

# to upload an entire Rproject (RData extention) use the load function (it reloads saved datasets)
load("biomes_multivar.RData") 

# to see the files, use the ls function
ls()

# you name the tables to see them entirely
biomes  # plots vs species 
biomes_types  # plots vs biomes 

head(biomes) # to see just the first rows

# we will use decorana: detrended correspondence analysis (when you have several axes and you want to squeeze them in a smaller amount of axes)
multivar <- decorana(biomes)
multivar  # it explains the analysis 

# to see all the previous plots squeezed in just 2 axes (2 dimensions)
plot(multivar) 

# to see the different biomes (circle the points that belong to the same biome)
attach(biomes_types) # state that we are using that table

# use the function ordiellipse to display groups in ordination diagrams
ordiellipse(multivar, type, col=c("black","red","green","blue"), kind = "ehull", lwd=3)  # type is telling R that we want to use different objects # kind stands for the type of ellipse # lwd is the line width
