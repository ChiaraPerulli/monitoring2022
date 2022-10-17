# This is a code for investigating relationships among ecological variables

# We are using the sp package, used for spacial data. To install it we use:
# install.packages("sp")
# to recall the function use the function library() or require()

library(sp) # you can also make use of require (sp)

# we are using meuse, search for "meuse dataset R sp package" 
# https://www.rdocumentation.org/packages/sp/versions/1.5-0/topics/meuse

# data is used to recall datasets
data(meuse) # this function is gathering the data 

# meuse is a dataframe (dataframe is the R name for "table")
# the function View is invoking a data viewer 

View(meuse) # it's important to use the capital letter

# dev.off() is used to destroy the specified plot

# if you're interested in using just some parts (the heads) of the table you can use the head function
head(meuse)

# another function shows you only the column names
names(meuse)

# to calculate the mean, the median, the minimum, the maximum (everything dealing with statistics) there is the summary function
summary(meuse)

# if you want to plot one variable in respect with another variable 
plot(cadmium, zinc) # you will receive an error because they are not single objects, but they are inside the table. The object is meuse. 
# we use the symbol $ to link things to each other 

plot(meuse$cadmium, meuse$zinc) # these columns are inside meuse 
# to summarize, you can build another object with the assignation simbol <-

cad<-meuse$cadmium
zin<-meuse$zinc

# now you can use the plot in a simpler way 
plot (cad, zin)

# another solution (used especially with dataframes) is to attach the table and then you can simply use the names of the columns (since you attached the dataframe)
attach(meuse)
plot(cadmium, zinc)

# if you want, there is also a function to detach
# detach (meuse)

# to see the relationships between all the variables (instead of doing the single plots) there is the function pairs 
# pairs is a scatterplot matrics
pairs(meuse) # you will see all the possible plots (instead of plotting 14*(14-1)= 182 combinations!)

# you can change the colour of the plots
pairs(meuse, col="blue")

# to change the colour of the graph, recall the previous function and add the argument col. Colours are stored inside R as quotes.
plot(cadmium, zinc, col='red')

# to change the size of the dots, use the function cex (see the numbers on the Internet).
plot(cadmium, zinc, col='red', cex=2)

# to plot only a few variables, there are many manners:
## 1 making a subset with the symbol []: select only some columns, from 3 to 6. To explain the starting point of the selection use the comma.
meuse[,3:6]

# to name the subset, you can make use of the arrow (assignment)
pol<-meuse[,3:6] # now we have a new object 

# to show just a few rows of the new object (pol) use the function head
head(pol) # it shows the first 6-7 lines

# to pair these data
pairs(pol,col="blue",cex=1.5)

## 2 using the name of the columns
pairs(~cadmium + copper + lead + zinc ,data=meuse)  # the symbol tilde ~ (Alt 126) is important in modelling when you use +
pairs(~cadmium + copper + lead + zinc ,data=meuse, col="yellow")

# to change the character of the points use pch
pairs(~cadmium + copper + lead + zinc ,data=meuse, col="yellow", pch=19)

# there is a function in sp which is called coordinates which is useful to show spacial variability
coordinates(meuse)=~x+y  # you create a spacial plot
# now the meuse is a spacial dataset  

# to plot every single variable in the space we use the function:  spplot (dataset, "variable", main="describing text")
spplot(meuse, "zinc", main="Concentration of zinc")

# to make a spacial plot of several variables
spplot(meuse, c("copper", "zinc")) # this is an array (group of objects), that needs to be named with a c

# to change the size of the dots in a spacial graph use the function bubble
bubble(meuse, "zinc", main="Concentration of zinc") # the size increases according to the size of the variable 















