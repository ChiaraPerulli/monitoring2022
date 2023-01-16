# Usnea longissima dataset ----

# Create an R project

# packages needed ----
install.packages("dismo")

library(dismo)

# Download the dataset drom GBIF 
usnea <- gbif("Usnea", "longissima", download = T)

# Filter the dataset 
