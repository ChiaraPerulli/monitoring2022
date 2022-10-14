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

# another solution (used especially with dataframes) is to attach (symbol @) the table and then you can simply use the names of the columns (since you attached the dataframe)
attach(meuse)
plot(cadmium, zinc)

# if you want, there is also a function to detach
# detach (meuse)

# to see the relationships between all the variables (instead of doing the single plots) there is the function pairs 
# pairs is a scatterplot matrics
pairs(meuse) # you will see all the possible plots 










