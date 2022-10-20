# R_code_ggplot2.r

# R code for ggplot2 based graphs

# install ggplot2
install.packages("ggplot2")

library(ggplot2)

# we are going to create a dataframe with two invented variables
virus <- c(10, 30, 40, 50, 60, 80)  # the values are measured virus cases in a certain place
death <- c(100, 240, 310, 470, 580, 690) 
# we have created two arrays

plot(virus, death, pch=19, cex=2) # to see the relationship between them

# to build a table, a dataframe, use the function data.frame naming the columns
data.frame(virus, death) # virus is the first argument, therefore the first column

# we will assign the dataframe to an object
d <- data.frame(virus, death)

# to know the mean amount of virus/death in an area you can use the function summary (univariate statistics)
summary(d)

# we will use the function ggplot(data, aesthetics). The aesthetics are the variables that we want to use. 
#To explain the geometry we want to use (points in this case), there is the function geom_point. In ggplot you can add the function with a +. You prepare the plot, and then you explain the geometry you want to use. 
ggplot(d, aes(x=virus, y=death)) + geom_point()

# you can change the points directly inside the geom_point function
ggplot(d, aes(x=virus, y=death)) + geom_point(size=5, col="red", pch=17)

# if you want to change the points in a line, for instance, you can use the function geom_line
ggplot(d, aes(x=virus, y=death)) + geom_line(size=5, col="red", pch=17)

# you can use several geometries all together, simply putting a + 
ggplot(d, aes(x=virus, y=death)) + geom_line(size=2, col="red") + geom_point(size=3, col="blue", pch=17)

# there is also the function geom_polygon() to use areas
ggplot(d, aes(x=virus, y=death)) + geom_point(size=3, col="blue", pch=17) + geom_polygon()
