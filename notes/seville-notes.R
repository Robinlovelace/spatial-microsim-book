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

####################################################
# spatial data with R - CakeMap for all zones

ind <- read.csv("data/CakeMap/ind.csv")
cons <- read.csv("data/CakeMap/cons.csv")
# Load constraints separately - normally this would be first stage
con1 <- cons[1:12] # load the age/sex constraint
con2 <- cons[13:14] # load the car/no car constraint
con3 <- cons[15:24] # socio-economic class

# Rename the categories in "ind" to correspond to the one of cons
ind$Car <- sapply(ind$Car, FUN = switch, "Car", "NoCar")
ind$Sex <- sapply(ind$Sex, FUN = switch, "m", "f")
ind$NSSEC8 <- as.factor(ind$NSSEC8)
levels(ind$NSSEC8) <- colnames(con3)
ind$ageband4 <- 
  gsub(pattern = "-", replacement = "_", x = ind$ageband4)

# Initialise weights
weight_init_1zone <- table(ind)
init_cells <- rep(weight_init_1zone, each = nrow(cons))

# Define the names
names <- c(list(rownames(cons)),
           as.list(dimnames(weight_init_1zone)))

# Structure the data
weight_all <- array(init_cells, dim = 
                      c(nrow(cons), dim(weight_init_1zone)),
                    dimnames = names)

# Transform con1 into an 3D-array : con1_convert
names <- c(list(rownames(cons)),dimnames(weight_all)[c(4,6)])
con1_convert <- array(NA, dim=c(nrow(cons),2,6), dimnames = names)

for(zone in rownames(cons)){
  for (sex in dimnames(con1_convert)$Sex){
    for (age in dimnames(con1_convert)$ageband4){
      con1_convert[zone,sex,age] <- con1[zone,paste(sex,age,sep="")]
    }
  }
}

# Rescale con3 since it has some inconsistent constraints
con3_prop <- con3*rowSums(con2)/rowSums(con3)

# Load mipfp package
library(mipfp)

# Loop on the zones and make each time the mipfp
# To run in parallel: use foreach package
con1m = con1_convert
con2m = as.matrix(con2)
con3m = as.matrix(con3_prop)
descript <- list(c(3,5),2,4)

for (i in 1:nrow(cons)){
  target <- list(con1m[i,,], con2m[i,], con3m[i,])
  res <- Ipfp(weight_init_1zone, descript,target)
  weight_all[i,,,,,] <- res$x.hat
}

# Results for zone 1
weight_init_1zone <- weight_all[1,,,,,]

# Validation
aggr <- apply(weight_all,c(1,6,4),sum)
aggr <- aggr[,,c(2,1)] # order of sex to fit cons
aggr1 = as.data.frame(aggr)
con2 = apply(weight_all,c(1,3),sum)
con3 = apply(weight_all,c(1,5),sum)
ind_agg <- cbind(aggr1,con2,con3)

plot(as.matrix(ind_agg[1,]), as.matrix(cons[1,]), xlab = 'Simulated', ylab='Theoretical', main =' Validation for zone 1')

cor(as.vector(as.matrix(ind_agg)),as.vector(as.matrix(cons)))


CorVec <- rep (0, nrow(cons))

for (i in 1:nrow(cons)){
  CorVec[i] = cor(as.numeric(ind_agg[i,]),as.numeric(cons[i,]))
}

which(CorVec< 0.99)

# integerisation
expa = as.data.frame.table(weight_init_1zone, responseName = 'COUNT')

truncated = expa
truncated$COUNT = floor(expa$COUNT)
p = expa$COUNT - truncated$COUNT
n_missing = sum(p)
index = sample(1:nrow(truncated), size = n_missing, prob = p,replace=FALSE)
truncated$COUNT[index] = truncated$COUNT[index] + 1

# see simPop-notes.R for notes on simPop


# spatial data - using this repo
# https://github.com/Robinlovelace/Creating-maps-in-R

url_maps = 
  unzip()
library(raster)
system.time(
  lnd <- shapefile("data/london_sport.shp")
)
class(lnd)  
plot(lnd)
library(sf)
system.time(
  lnd_sf <- st_read("data/london_sport.shp")
)
plot(lnd_sf)

r = raster(lnd)
values(r) = 1:100
plot(r)
plot(lnd, add = T)
proj4string(lnd)
lnd_geo = spTransform(lnd, CRS("+proj=longlat +datum=WGS84"))
proj4string(lnd_geo)
spDists(lnd_geo[1:3,])
spDists(lnd[1:3,])
raster::res(r)
res(r)
detach("package:raster")
raster::res(r)
res(r)
library(raster)
r_highes = r
raster::res(r_highes) <- 1000
values(r_highes) = 1:ncell(r_highes)
plot(r_highes)

# further resources: http://geostat-course.org/node

# Generate spatial microdata
source("notes/mipfp-notes.R")

# Getting spatial data for Belgium
u_bel = "http://biogeo.ucdavis.edu/data/gadm2.8/rds/BEL_adm4.rds"
download.file(u_bel, "BEL_adm4.rds")
bel = readRDS("BEL_adm4.rds")
plot(bel)
d = bel@data
nam = bel[bel$NAME_2 == "Namur",]
nam = nam[sample(length(nam), length(uz)),]
plot(nam)
d = nam@data
# str(nam) # show structure
uz = unique(synth_namur$id)
nam$id = uz[sample(length(uz), length(uz))]
# check the ids match
summary(nam$id %in% pmale$id)
nam@data = inner_join(nam@data, pmale)
head(nam@data)
tmap::qtm(nam, "pmale")

library(tmap)
tmap_mode("view")
qtm(nam, "pmale", n = 3)
tm_shape(nam) +
  tm_fill(col = "pmale",
          breaks = c(0, 0.5, 1))

# Challenges:
# 1: Write a for loop to create a spatial microdataset
# for all zones in namur (don't just copy my code!)
# 2: Create a map of a different variable (not % male)
# 3: Implement the methods on your own data
