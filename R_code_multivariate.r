# Community ecology example with R
## Multivariate analysis 

# Install the package vegan, a famous community ecology package
install.packages("vegan")
library(vegan)  

# Set the working directory
setwd("C:/lab/")

# To upload an entire Rproject (RData extention) use the load function (it reloads saved datasets)
load("biomes_multivar.RData") 

# To see the files, use the ls function
ls()

# You name the tables to see them entirely
biomes  # plots vs species 
biomes_types  # plots vs biomes 

head(biomes) # to see just the first rows

# We will use decorana: detrended correspondence analysis (when you have several axes and you want to squeeze them in a smaller amount of axes)
multivar <- decorana(biomes)
multivar  # it explains the analysis 

# To see all the previous plots squeezed in just 2 axes (2 dimensions)
plot(multivar) 

# To see the different biomes (circle the points that belong to the same biome)
attach(biomes_types)  # state that we are using that table

# Use the function ordiellipse to display groups in ordination diagrams
ordiellipse(multivar, type, col= c("black","red","green","blue"), kind= "ehull", lwd= 3)  
## "type" is telling R that we want that specific column in the biomes_types  
## "kind" stands for the type of ellipse 
## "lwd" is the line width

# Use the function ordispider with the same arguments (adding the labels) to connect the points of a certain biome
ordispider(multivar, type, col= c("black","red","green","blue"), kind= "ehull", lwd= 3, label= T)  

# We can save our graph as a pdf out of R
pdf("myfirstoutput.pdf")
## Repeat all the functions that you want to include in the pdf
plot(multivar)
ordiellipse(multivar, type, col= c("black","red","green","blue"), kind= "ehull", lwd= 3)  
ordispider(multivar, type, col= c("black","red","green","blue"), kind= "ehull", lwd= 3, label= T)  
## Close the pdf
dev.off()
## You should find the pdf in the lab folder! :)

# Exercise: export a pdf with only the multivar plot
pdf("mysecondoutput.pdf")
plot(multivar)
dev.off()
