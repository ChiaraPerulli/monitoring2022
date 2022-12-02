# R code on Greenland ice melt

library(raster)

# set the working directory
setwd("C:/lab/")

# import the data (4 datasets)
lst_2000 <- raster("lst_2000.tif")

# Exercise: plot the lst_2000 with ggplot()
library(ggplot2)
library(RStoolbox)
library(viridis)
ggplot() + geom_raster (lst_2000, mapping=aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma")    # you can find the fill under "names"

# you can reverse the direction of the colours (direction=-1)
ggplot() + geom_raster (lst_2000, mapping=aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=-1)

# you can put a title
ggplot() + geom_raster (lst_2000, mapping=aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=-1) + ggtitle("Temperature 2000")

# you can put a level of transparency (higher alpha = lower transparency)
ggplot() + geom_raster (lst_2000, mapping=aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=1, alpha=0.2) + ggtitle("Temperature 2000")
ggplot() + geom_raster (lst_2000, mapping=aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma", direction=1, alpha=0.8) + ggtitle("Temperature 2000")

# Exercise: upload all the data (2005, 2010, 2015)
lst_2005 <- raster("lst_2005.tif")
lst_2010 <- raster("lst_2010.tif")
lst_2015 <- raster("lst_2015.tif")

# plot them 
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

# SIMPLER MANNER: with the function "lapply" you can apply a function over a list of files

# 1. first, make the list of the files
rlist <- list.files(pattern="lst")   # pattern= useful for R to catch the files inside the lab folder

# 2. apply the lapply function to the list
import <- lapply(rlist, FUN=raster)   # list: rlist, function: raster

# 3. use the function stack to go from the 4 files to a final single image
TGr <- stack(import)    # now you have a single file with the 4 layers

# 4. plot the data
plot(TGr)


















