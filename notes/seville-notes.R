# Welcome to the course's R notes
# All course material found/linked to:
# https://github.com/Robinlovelace/spatial-microsim-book
# examples will go here

# First challenge: get set-up on RStudio server
# https://rstudio.jrc.es/

# test if your RStudio account works:
# example of interactive plotting
library(tmap)
tmap_mode("view")
example(qtm)

# downloading and unzipping data
url_msim = "https://github.com/Robinlovelace/spatial-microsim-book/archive/master.zip"
download.file(url_msim = "https://github.com/Robinlovelace/spatial-microsim-book/archive/master.zip", destfile = "master.zip")
unzip("master.zip")

# Notes on project management:
# https://csgillespie.github.io/efficientR/

# for spatial data
u = "https://github.com/Robinlovelace/vspd-base-shiny-data/archive/master.zip"
download.file(u, destfile = "master.zip")
unzip("master.zip")
dir.create("data")
f = list.files(path = "vspd-base-shiny-data-master/",
               full.names = T)
file.copy

# plot x and y 
x = 1:99
y = x^3
y = plot(x, y)
system.time({x = 1:99})

# example of tab autocompletion:
# use tab inside funtion calls to find arguments
system2(command = "ls", args = "-hal")

# loading in data
ind = read.csv("data/SimpleWorld/ind-full.csv")
nrow(ind)
head(ind)
# look at the environment pane to see it
# click on it or enter View(ind) to see it
View(ind)

# classes
class(ind)
class(ind$age)
class(ind$sex)

# subsetting data
ind[5,] # select row
ind[,3]
ind[3]
ind["sex"]
ind$sex

# Alternative way of data handling
# dplyr rule: always returns a data fram
# concept: type stability
library(dplyr)
slice(ind, 5) 
select(ind, sex)

# class coercion
ind_mat = as.matrix(ind)
class(ind_mat[1,])


# spatial data with R
