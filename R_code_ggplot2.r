# R code for ggplot2 based graphs

# Install ggplot2
install.packages("ggplot2")

# Recall the package
library(ggplot2)

# We are going to create a dataframe with two invented variables
virus <- c(10, 30, 40, 50, 60, 80)  # the values are measured virus cases in a certain place
death <- c(100, 240, 310, 470, 580, 690) 
# We have created two arrays

plot(virus, death, pch=19, cex=2) # to see the relationship between them

# To build a table, a dataframe, use the function data.frame naming the columns
data.frame(virus, death)  # virus is the first argument, therefore the first column

# We will assign the dataframe to an object
d <- data.frame(virus, death)

# To know the mean amount of virus/death in an area you can use the function summary (univariate statistics)
summary(d)

# We will use the function ggplot(data, aesthetics). The aesthetics are the variables that we want to use. 
# To explain the geometry we want to use (points in this case), there is the function geom_point. In ggplot you can add the functions with a +. You prepare the plot, and then you explain the geometry you want to use. 
ggplot(d, aes(x=virus, y=death)) + geom_point()

# You can change the points directly inside the geom_point function
ggplot(d, aes(x=virus, y=death)) + geom_point(size=5, col="red", pch=17)

# If you want to change the points in a line, for instance, you can use the function geom_line
ggplot(d, aes(x=virus, y=death)) + geom_line(size=5, col="red", pch=17)

# You can use several geometries all together, simply putting a + 
ggplot(d, aes(x=virus, y=death)) + geom_line(size=2, col="red") + geom_point(size=3, col="blue", pch=17)

# There is also the function geom_polygon() to use areas
ggplot(d, aes(x=virus, y=death)) + geom_point(size=3, col="blue", pch=17) + geom_polygon()

################################ 21.10.2022 ############################################

# Create a folder called lab and save the csv covid_agg inside it

# To connect the csv with R, use the function setwd (set working directory). It is used to explain which working directory R has to use.
setwd("C:/lab/") # explain to R the path of the folder (look in the properties of the folder)

# Use the function read.table(file name, header=FALSE, sep="") to use the csv
## There is a part of the table which is just naming the columns (header). 
## sep means separator, that is the symbol that separates the cokumns
read.table("covid_agg.csv")

# We assign the function to an object
covid <- read.table("covid_agg.csv")

# To see just a few lines use the function head
head(covid)

# We should explain to R that in our table cat, country, cases, lat and lon are headers and not variables. Therefore we use the argument header=TRUE.
read.table("covid_agg.csv", header=TRUE)  # write TRUE or T 

covid <- read.table("covid_agg.csv", header=TRUE)

# To see some summary statistics
summary(covid)

# Create the plot with x is the longitude and y is the latitude and explainthe geometry you want to use 
ggplot(covid, aes(x=lon, y=lat)) + geom_point(col="red", size=4)

# You can change the size of the points relating them with the number of cases
ggplot(covid, aes(x=lon, y=lat, size=cases)) + geom_point(col="red", pch=11)
