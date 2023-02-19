# MONITORING ECOSYSTEM CHANGES AND FUNCTIONING PROJECT ----
# Chiara Perulli

# The project aims to investigate how changes in temperature affect birch pollen emission and how this, in turn, impacts allergy sufferers. 

# Install the following packages
install.packages("ncdf4")
install.packages("raster")
install.packages("sp")
install.packages("ggplot2")
install.packages("RStoolbox")
install.packages("viridis")
install.packages("patchwork")
install.packages("scales")
install.packages("sdm")   
install.packages("rgdal")
install.packages("dplyr")

# Recall the packages
library(ncdf4)       # reading and writing netCDF files
library(raster)      # manipulating raster data
library(sp)          # managing spatial data
library(ggplot2)     # creating plots
library(RStoolbox)   # managing remote sensing data
library(viridis)     # color palettes
library(patchwork)   # combining multiple ggplot2 plots
library(scales)      # managing scales and color palettes
library(sdm)         # species distribution modelling
library(rgdal)       # managing geospatial data
library(dplyr)       # manipulating data (filtering, selecting, ...)
library(spatstat)    # analyzing spatial point patterns

# First of all, set the working directory
setwd("C:/monitoring_exam/")

# GBIF Betula occurrences ----
# Data downloaded from GBIF for the year 2020
# https://www.gbif.org/dataset/search?q=

# Import the data for 2020
Betula2020 <- read.csv2("0264519-220831081235567.csv", sep="\t")   # The file is tab-separated

# Filter the data
Betula2020 <- Betula2020 %>% 
  filter(!is.na(decimalLongitude)) %>%  # Eliminate rows with missing values for longitude
  filter(!is.na(decimalLatitude)) %>%   # Eliminate rows with missing values for latitude
  filter(!is.na(year)) %>%              # Eliminate rows with missing values for year
  filter(basisOfRecord %in% c("HUMAN_OBSERVATION", "OBSERVATION")) %>%   # Filter the data to only include rows where the values in the "basisOfRecord" column are either "HUMAN_OBSERVATION" or "OBSERVATION"
  select(decimalLongitude, decimalLatitude, year) %>%  # Select the columns for latitude, longitude and year
  filter(decimalLongitude >= -20 & decimalLongitude <= 70 & decimalLatitude >= 20 & decimalLatitude <= 75) # Filter data for Europe

# Inspect the data
summary(Betula2020) 

# Longitude and latitude have the same length, but they are considered characters!
# Check for the class of the columns
class(Betula2020$decimalLongitude)   # It shouldn't be a character!
class(Betula2020$decimalLatitude)    # It shouldn't be a character!
# Change the class to numeric
Betula2020$decimalLongitude <- as.numeric(Betula2020$decimalLongitude)
Betula2020$decimalLatitude <- as.numeric(Betula2020$decimalLatitude)
# Check if the type of latitude and longitude has changed
typeof(Betula2020$decimalLatitude)
typeof(Betula2020$decimalLongitude)

# Eliminate duplicated values
Betula2020 <- unique(Betula2020)


###### There is another way to download GBIF data, without setting the working directory
# install.packages("dismo")
# library(dismo)
# GBIF data are downloaded directly into R:
# Betula <- gbif("Betula", download = T)


# POINT PATTERN ANALYSIS ----
# Use the prepared dataset to create a map that shows the occurrences of birch in Europe

attach(Betula2020)
# Create a spatial point pattern (ppp) object from the x and y coordinates of the data points
Betula2020_map <- ppp(x=Betula2020$decimalLongitude, y=Betula2020$decimalLatitude, c(-20, 70), c(20, 75))   # coordinates for Europe c(N, S), c(W, E)
# First, create a color palette
cl <- colorRampPalette(c("white", "olivedrab1", "olivedrab3", "olivedrab4" ))(100)
# Add the density
Betula_density_map <- density(Betula2020_map)
# Plot the density map
plot(Betula_density_map, col=cl, main="Birch distribution in 2020")
# Add the points to the previous map
points(Betula2020_map, pch=20, col="darkolivegreen", cex=0.1)
# Add the coastlines
coastlines <- readOGR("ne_10m_coastline.shp")
# Crop the coastlines with the previous extent
coastlines_eu <- crop(coastlines, extent(-20, 70, 20, 75))
# Plot the final map
plot(coastlines_eu, add=T)

# PDF OCCURRENCES ----
# Create a pdf to save the occurrences

pdf("birch_2020_map.pdf", height = 5)   # Name the PDF file and set the height to see the title near the map

# Repeat the previous code
attach(Betula2020)
# Create a spatial point pattern (ppp) object from the x and y coordinates of the data points
Betula2020_map <- ppp(x=Betula2020$decimalLongitude, y=Betula2020$decimalLatitude, c(-20, 70), c(20, 75))   
# First, create a color palette
cl <- colorRampPalette(c("white", "olivedrab1", "olivedrab3", "olivedrab4"))(100)
# Add the density
Betula_density_map <- density(Betula2020_map)
# Plot the density map
plot(Betula_density_map, col=cl, main="Birch distribution in 2020")
# Add the points to the previous map
points(Betula2020_map, pch=20, col="darkolivegreen", cex=0.1)
# Add the coastlines
coastlines <- readOGR("ne_10m_coastline.shp")
# Crop the coastlines with the previous extent
coastlines_eu <- crop(coastlines, extent(-20, 70, 20, 75))
# Plot the final map
plot(coastlines_eu, add=T)

dev.off()     # Close the PDF
getwd()       # See where it has been saved


# SURFACE TEMPERATURE ----
# Data downloaded from CAMS global reanalysis (EAC4) monthly averaged fields:
# https://ads.atmosphere.copernicus.eu/cdsapp#!/dataset/cams-global-reanalysis-eac4-monthly?tab=form

####### 2010

# Import the image in R
## March 2010 averaged surface temperature (2 m from surface)
t_march_2010 <- raster("adaptor.mars.internal-1675109503.2263746-22460-9-1599b0aa-4533-4706-b778-79fddc6fd8fa.grib")
t_march_2010

# SFC..Ground.or.water.surface...2.metre.temperature..C. is the name of the layer
# I want to use European data
ext <- c(-20, 70, 20, 75)    # These are the coordinates that include Europe (ext = extension)
t_march_2010_eu <- crop(t_march_2010, ext)      # Crop the previous map

# Plot the European monthly averaged surface temperature on March 2010
map_K <- ggplot() + 
  geom_raster (t_march_2010_eu, mapping=aes(x=x, y=y, fill=SFC..Ground.or.water.surface...2.metre.temperature..C.)) + 
  scale_fill_viridis(option="inferno", name="K") +
  ggtitle("March 2010 temperature") 
map_K

# The temperatures are measured in K
# Create a function to transform the temperature from K to °C
kelvin_to_celsius <- function(temp_k) {
  temp_c <- temp_k - 273.15
  return(temp_c)
}
# Apply the function to the previous map
t_march_2010_eu$SFC..Ground.or.water.surface...2.metre.temperature..C. <- kelvin_to_celsius(t_march_2010_eu$SFC..Ground.or.water.surface...2.metre.temperature..C.)

# Plot the map with the temperatures in °C
map_10 <- ggplot(t_march_2010_eu, aes(x=x, y=y, fill=SFC..Ground.or.water.surface...2.metre.temperature..C.)) + 
  geom_raster() + 
  scale_fill_viridis_c(option="inferno", name="°C") + 
  ggtitle("March 2010 temperature") 
map_10

# Let's see if the two maps show the same colors (if the function has worked!)
map_K + map_10 

###### 2015

# Import the image in R
## March 2015 averaged surface temperature (2 m from surface)
t_march_2015 <- raster("adaptor.mars.internal-1675110604.5636644-23293-16-98747ebe-44da-44d8-b147-1bebe85e5b81.grib")
t_march_2015

# Crop the data for Europe
ext <- c(-20, 70, 20, 75)    # These are the coordinates that include Europe
t_march_2015_eu <- crop(t_march_2015, ext)      

# Change the temperature from K to °C
t_march_2015_eu$SFC..Ground.or.water.surface...2.metre.temperature..C. <- kelvin_to_celsius(t_march_2015_eu$SFC..Ground.or.water.surface...2.metre.temperature..C.)

# Plot the map with the temperatures in °C
map_15 <- ggplot(t_march_2015_eu, aes(x=x, y=y, fill=SFC..Ground.or.water.surface...2.metre.temperature..C.)) + 
  geom_raster() + 
  scale_fill_viridis_c(option="inferno", name="°C") + 
  ggtitle("March 2015 temperature") 
map_15

###### 2020

# Import the image in R
## March 2020 averaged surface temperature (2 m from surface)
t_march_2020 <- raster("adaptor.mars.internal-1675111424.324812-1761-12-a754cc07-fcea-43b4-90e2-1db8fe48a0de.grib")
t_march_2020

# Crop the data for Europe
ext <- c(-20, 70, 20, 75)    # These are the coordinates that include Europe
t_march_2020_eu <- crop(t_march_2020, ext)      

# Change the temperature from K to °C
t_march_2020_eu$SFC..Ground.or.water.surface...2.metre.temperature..C. <- kelvin_to_celsius(t_march_2020_eu$SFC..Ground.or.water.surface...2.metre.temperature..C.)

# Plot the map with the temperatures in °C
map_20 <- ggplot(t_march_2020_eu, aes(x=x, y=y, fill=SFC..Ground.or.water.surface...2.metre.temperature..C.)) + 
  geom_raster() + 
  scale_fill_viridis_c(option="inferno", name="°C") + 
  ggtitle("March 2020 temperature") 
map_20

# Compare the three maps
map_10 + map_15 + map_20


# POLLEN CONCENTRATION ---- 
# Analysis of the birch pollen concentration in Europe in the first 15 days of April 2020-2021-2022
# Data downloaded from the CAMS European air quality forecasts:
# https://ads.atmosphere.copernicus.eu/cdsapp#!/dataset/cams-europe-air-quality-forecasts?tab=form


# Create a color palette
pol_cl <- colorRampPalette(c("navy", "lightskyblue", "lightblue1", "rosybrown1", "salmon", "tomato4")) (100)

###### 2020

# Upload the data
pol2020 <- raster("adaptor.cams_regional_fc.retrieve-1676062837.0175316-4397-2-54d54f90-fd3c-4af3-89cc-9eec5407793b.grib")
pol2020
# Change the Coordinate Reference System
crs(pol2020) <- "EPSG:4326"
pol2020
# Create a map showing birch pollen concentration 
plot(pol2020, col=pol_cl)
# Add the coastlines
coastlines <- readOGR("ne_10m_coastline.shp")
# Crop the coastlines with the previous extent
coastlines_eu <- crop(coastlines, extent(-25, 45, 30, 72))   # These are the extents of the Rasterlayer
# Plot the final map
plot(coastlines_eu, add=T, col="white")


###### 2021

# Upload the data
pol2021 <- raster("adaptor.cams_regional_fc.retrieve-1676062706.278664-25815-8-38633116-dfb2-475d-b72e-ebaab9ab15d0.grib")
pol2021
# Change the Coordinate Reference System
crs(pol2021) <- "EPSG:4326"
pol2021
# Create a map showing birch pollen concentration
plot(pol2021, col=pol_cl)
# Add the coastlines
coastlines <- readOGR("ne_10m_coastline.shp")
# Crop the coastlines with the previous extent
coastlines_eu <- crop(coastlines, extent(-25, 45, 30, 72))   # These are the extents of the Rasterlayer
# Plot the final map
plot(coastlines_eu, add=T, col="white")

###### 2022

# Upload the data
pol2022 <- raster("adaptor.cams_regional_fc.retrieve-1676062581.1529057-14749-5-ef65c3a8-f508-46c4-9726-e9e1c30c29ba.grib")
pol2022
# Change the Coordinate Reference System
crs(pol2022) <- "EPSG:4326"
pol2022
# Create a map showing birch pollen concentration
plot(pol2022, col=pol_cl)
# Add the coastlines
coastlines <- readOGR("ne_10m_coastline.shp")
# Crop the coastlines with the previous extent
coastlines_eu <- crop(coastlines, extent(-25, 45, 30, 72))   # These are the extents of the Rasterlayer
# Plot the final map
plot(coastlines_eu, add=T, col="white")


# POLLEN TREND ---- 

# Stack the three maps together
pollen <- stack(pol2020, pol2021, pol2022)
# Rename the layers
names(pollen) <- c("Birch pollen 2020", "Birch pollen 2021", "Birch pollen 2022")
# Add the coastlines
coastlines <- readOGR("ne_10m_coastline.shp")
# Crop the coastlines with the previous extent
coastlines_eu <- crop(coastlines, extent(-25, 45, 30, 72))   # These are the extents of the Rasterlayer
# Display the maps in a 2x3 grid
par(mfrow = c(1, 3))
# Loop through each layer of the stacked data to add the coastlines to each plot
for (i in 1:nlayers(pollen)) {
  plot(pollen[[i]], col=pol_cl, main=paste(names(pollen)[i]))
  plot(coastlines_eu, add=TRUE, col="white")
}

dev.off()


# The pairs function is used to visualize the relationships between multiple variables
pairs(pollen)

# BOXPLOT of the pollen concentrations in the three years
boxplot(pollen, outline=F, names=c("2020", "2021", "2022"), main="Pollen trend", col=c("darkolivegreen2"))

# TEMPERATURE TREND -----
# Data downloaded from CAMS global reanalysis (EAC4) monthly averaged fields:
# March averaged surface temperature in 2020, 2021 and 2022
# https://ads.atmosphere.copernicus.eu/cdsapp#!/yourrequests?tab=form

####### 2020
Mar2020 <- raster("adaptor.mars.internal-1676059492.887645-15030-2-9c53acc9-8083-480d-84c3-966b0a276067.grib")
Mar2020
# Change the Coordinate Reference System
crs(Mar2020) <- "EPSG:4326"
Mar2020


###### 2021
Mar2021 <- raster("adaptor.mars.internal-1676059382.8441732-23150-5-dbda6200-43f7-4694-b670-93735e85e3f0.grib")
Mar2021
# Change the Coordinate Reference System
crs(Mar2021) <- "EPSG:4326"
Mar2021


###### 2022
Mar2022 <- raster("adaptor.mars.internal-1676059146.3451464-12003-4-aad6450e-9f66-4b6d-9a84-66d0e686c027.grib")
Mar2022
# Change the Coordinate Reference System
crs(Mar2022) <- "EPSG:4326"
Mar2022
 

# Stack the three maps together
temp <- stack(Mar2020, Mar2021, Mar2022)
# Transforme the temperature from K to °C
temp_celsius <- temp - 273.15
names(temp_celsius) <- c("Temperature March 2020", "Temperature March 2021", "Temperature March 2022")
# Plot the maps with the color palette
pol_cl <- colorRampPalette(c("navy", "lightskyblue", "lightblue1", "rosybrown1", "salmon", "tomato4")) (100)
plot(temp_celsius, col=pol_cl)

# Visualize the relationships between the variables
pairs(temp_celsius)

# BOXPLOT of the March averaged surface temperature in the three years
boxplot(temp_celsius, outline=F, names=c("2020", "2021", "2022"), main = "Temperature trend", col=c("salmon"))

# POLLEN-TEMPERATURE ANALYSIS ----
# Display the boxplots showing the trends in temperature and pollen side by side

pdf("boxplots.pdf", height=5.5)   # Save them in a PDF with height 5.5

par(mfrow=c(1,2))    

boxplot(temp_celsius, outline=F, names=c("2020", "2021", "2022"), main="Temperature trend", col=c("salmon"))
boxplot(pollen, outline=F, names=c("2020", "2021", "2022"), main="Pollen trend", col=c("darkolivegreen2"))

dev.off()

# VISUALIZATION POLLEN-TEMPERATURE TRENDS ----
# See all the maps (temperature and pollen) together and create a PDF to save them

pdf("stacked maps.pdf")

# Resample to reference data extent
temp1 <- resample(temp_celsius, pollen, method="bilinear")
# Stack the datasets together
merged <- stack(pollen, temp1)
# Display the maps in a 2x3 grid
par(mfrow=c(2, 3))
# Loop through each layer of the stacked data to add the coastlines to each plot
for (i in 1:nlayers(merged)) {
  plot(merged[[i]], col=pol_cl, main=paste(names(merged)[i]))
  plot(coastlines_eu, add=TRUE, col="white")
}
# Within each iteration of the loop, 'plot' is used to display the raster layer. 
# Then 'plot' is used again with the 'add' argument set to 'TRUE' to superimpose the 'coastlines_eu' layer. 
# The title of each plot is set with the 'main' argument.

dev.off()


# EUROSTAT DATA ----
# Analysis of the European and Italian data about respiratory diseases (2014 vs 2019)
# Data downloaded from Eurostat website:
# https://ec.europa.eu/eurostat/databrowser/view/HLTH_EHIS_CD1C__custom_4786687/default/table?lang=en

# Import the data 
allergy <- read.table("hlth_ehis_cd1c_linear.csv.gz", header=TRUE, sep=",")  # header = T : the first row of the file contains the column names
allergy 
summary(allergy)

## Clean the data
# Select the columns you are interested in (health problem, country, year and percentage of population affected by the health problem)
allergy <- allergy[, c("hlth_pb", "geo", "TIME_PERIOD", "OBS_VALUE")]  

# Check all the unique data contained in the column "geo"
unique(allergy$geo)
# Eliminate "EU27_2020" and "EU28" values from the "geo" column
allergy <- subset(allergy, allergy$geo != "EU27_2020")
allergy <- subset(allergy, allergy$geo != "EU28")
# Check if the rows have been eliminated
unique(allergy$geo)

# Chech all the unique data contained in the column "hlth_pb"
unique(allergy$hlth_pb)

# Filter the data
allergy_eu <- allergy %>% 
  filter(!is.na(geo)) %>%           # Eliminate rows with missing values for "geo" (country)
  filter(!is.na(hlth_pb)) %>%       # Eliminate rows with missing values for "hlth_pb" (health problem)
  filter(!is.na(TIME_PERIOD)) %>%   # Eliminate rows with missing values for "TIME_PERIOD" (year)
  filter(!is.na(OBS_VALUE)) %>%     # Eliminate rows with missing values for "OBS_VALUE" (% of population affected by the health problem)
  filter(hlth_pb %in% c("ALLGY"))   # Select the rows that contain information on allergic diseases
# Check if there are any remaining NA values
any(is.na(allergy_eu))   # FALSE

###### Compare the % of European citizens that suffer from respiratory diseases in the two years

# In ggplot2, the x axis is treated as a categorical variable when the column is stored as a factor, but as a continuous variable when the column is stored as a character or numeric type
typeof(allergy_eu$TIME_PERIOD)   # integer
# Change to factor
allergy_eu$TIME_PERIOD <- factor(allergy_eu$TIME_PERIOD)
glimpse(allergy_eu$TIME_PERIOD)   # factor

# Create the boxplot and save it as a PDF

pdf("Europe.allergy.pdf")

ggplot(allergy_eu, aes(x=TIME_PERIOD, y=OBS_VALUE, fill=TIME_PERIOD)) +
  geom_boxplot() +
  xlab("Year") +
  ylab("Percentage of population") +
  labs(fill="Year") +
  scale_fill_manual(values=c("olivedrab1", "olivedrab4")) +
  scale_x_discrete(limits=c("2014", "2019")) +
  ggtitle("European citizens with respiratory diseases") +
  theme_light() +
  theme(plot.title=element_text(hjust=0.5))

dev.off()
  
# Test if there has been an increase in allergic diseases from 2014 to 2019 
allergy_2014 <- allergy_eu[allergy_eu$TIME_PERIOD == "2014",]
allergy_2019 <- allergy_eu[allergy_eu$TIME_PERIOD == "2019",]

# Compare the mean values for the two years
mean(allergy_2014$OBS_VALUE)   # 13.94149
mean(allergy_2019$OBS_VALUE)   # 14.86791


######  Compare the % of Italian citizens that suffer from respiratory diseases in the two years

# Filter the country IT in the "geo" column
allergy_IT <- allergy_eu %>%
  filter(geo %in% c("IT")) %>%
  filter (hlth_pb %in% c("ALLGY"))

allergy_IT
glimpse(allergy_IT)

# Create the boxplot and save it as a PDF

pdf("Italy.allergy.pdf")

ggplot(allergy_IT, aes(x=TIME_PERIOD, y=OBS_VALUE, fill=TIME_PERIOD)) +
  geom_boxplot() +
  xlab("Year") +
  ylab("Percentage of population") +
  labs(fill="Year")+
  scale_fill_manual(values=c("olivedrab1", "olivedrab4"))+
  scale_x_discrete(limits=c("2014", "2019")) +
  ggtitle("Italian citizens with respiratory diseases") +
  theme_light() +
  theme(plot.title=element_text(hjust=0.5)) 

dev.off()

