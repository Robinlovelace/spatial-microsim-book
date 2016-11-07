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
u = "https://github.com/Robinlovelace/vspd-base-shiny-data/archive/master.zip"
download.file(u, destfile = "master.zip")
unzip("master.zip")
dir.create("data")
f = list.files(path = "vspd-base-shiny-data-master/",
               full.names = T)
file.copy(f, "data")



# spatial data with R



