############################################
#### From the spatial-microsim-book project  
#### https://github.com/Robinlovelace/spatial-microsim-book
############################################

# Additions from Ben Anderson (@dataknut)

# Loading the data: Ensure R is in the right working directory 
ind <- read.csv("data/CakeMap/ind.csv")
cons <- read.csv("data/CakeMap/cons.csv")

# Take a quick look at the data
head(ind)
head(cons)

# load constraints separately - normally this would be first stage
con1 <- cons[1:12] # load the age/sex constraint
con2 <- cons[13:14] # load the car/no car constraint
con3 <- cons[15:24] # socio-economic class

cat_labs <- names(cons) # category names, from correct from cons.R

# set-up aggregate values - column for each category
source("data/CakeMap/categorise.R") # this script must be customised to input data

# check constraint totals - should be true
sum(ind_cat[,1:ncol(con1)]) == nrow(ind) # is the number in each category correct?
sum(ind_cat[,ncol(con1)+1:ncol(con2)]) == nrow(ind) 

# create 2D weight matrix (individuals, areas)
weights <- array(NA, dim=c(nrow(ind),nrow(cons))) 

# convert survey data into aggregates to compare with census (3D matix)
ind_agg <- matrix(colSums(ind_cat), nrow(cons), ncol(cons), byrow = T)
ind_agg[1:5,1:10] # look at what we've created - n. individuals replicated throughout

############## The IPF part #############

library(ipfp)
cons <- apply(cons, 2, as.numeric)
ind_catt <- t(ind_cat)
# set up initial vector as a load of 1s
x0 <- rep(1, nrow(ind))
# you can use x0 as a way to start from the original survey weights
# as it just has to be a numeric initial vector (length ncol)
# this might be useful if you have a small number of constraints but
# if you have many the effect of the IPF will tend to drown them out

weights <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, 20))

### Convert back to aggregates for testing
for (i in 1:nrow(cons)){ # convert con1 weights back into aggregates
  ind_agg[i,]   <- colSums(ind_cat * weights[,i])}

# test results for first row (not necessary for model)
# you could iterate over this to test each zone
ind_agg[1,1:15] - cons[1,1:15] # should be zero for final column - last constraint
# which should remind us that IPF works to an order - so the last constraint is
# fitted perfectly. This might matter if you think other constraints should be fitted perfectly...
cor(as.numeric(ind_agg), as.numeric(cons)) # fit between contraints and estimate

# at this point RL wants to integrise to create a spatial microdataset of whole 'units'
# But we don't have to - for many applications we may want to keep all the survey units (people or households)
# with their fractional weights to avoid losing information. It also helps if we're interested in distributional
# statistics for each area.

# to do this simply join the weights matrix back on to the original individual data
# we have to assume R has kept them in the correct order!

# just do a column bind
ind_final <- cbind(ind,weights)
View(ind_final)
# so now we have a weight for each individual for each zone and from here on we can do 
# a range of weighted statistics or collapse to tables by zone etc etc
# Would be a good idea at this point to rename the zone columns to their actual geography.