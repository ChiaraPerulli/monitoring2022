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
