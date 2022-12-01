# How to download and analyse Copernicus data

# Copernicus site:
# https://land.copernicus.vgt.vito.be/PDF/portal/Application.html

# install.packages("ncdf4")

# recall these libraries
library(ncdf4)   # reading nc. files
library(raster)   # usual package
library(ggplot2)   # beautiful plots
library(RStoolbox)   # RS functions
library(viridis)    # legends - colour gamut
library(patchwork)   # multiframe ggplot

# to import the data use the following functions:
# brick function (more layers)
# raster function (for just one layer per time)

# First of all, set the working directory
setwd("C:/lab/")

# import the image in R
snow <- raster("c_gls_SCE_202012210000_NHEMI_VIIRS_V1.0.1.nc")

# Snow.Cover.Extent is the name of the layer

# Exercise: based on you previous code, plot the snow cover with ggplot and viridis
ggplot() + geom_raster (snow, mapping=aes(x=x, y=y, fill=Snow.Cover.Extent)) + scale_fill_viridis(option="mako") 
# fill = layer's name

# The data are rough because the resolution is 1km (it depends on the resolution of your original file) 

# If you want to use just European data there are different manners:
# 1. Draw an extent (don't do it, since it's difficult to replicate the same drawing)
# 2. Use coordinates

# ext = extension
ext <- c(-20, 70, 20, 75)    # min x, max x, min y, max y -> coordinates that include Europe

# Use the crop function to crop data
snow.europe <- crop(snow, ext)

# plot the image
ggplot() + geom_raster (snow.europe, mapping=aes(x=x, y=y, fill=Snow.Cover.Extent)) + scale_fill_viridis(option="inferno") 

# Exercise: plot the two sets with the patchwork package
library(patchwork)
g1 <- ggplot() + geom_raster (snow, mapping=aes(x=x, y=y, fill=Snow.Cover.Extent)) + scale_fill_viridis(option="mako") 
g2 <- ggplot() + geom_raster (snow.europe, mapping=aes(x=x, y=y, fill=Snow.Cover.Extent)) + scale_fill_viridis(option="inferno")


g1 + g2 
