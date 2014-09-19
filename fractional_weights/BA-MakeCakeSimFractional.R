############################################
#### From the spatial-microsim-book project  
#### https://github.com/Robinlovelace/spatial-microsim-book
############################################

# Additions from Ben Anderson (@dataknut)
# clear out all old objects etc to avoid confusion
rm(list = ls()) 

# Loading the data: Ensure R is in the right working directory 
ind <- read.csv("../data/CakeMap/ind.csv")
cons <- read.csv("../data/CakeMap/cons.csv")

# Take a quick look at the data
head(ind)
head(cons)

# load constraints separately - normally this would be first stage
con1 <- cons[1:12] # load the age/sex constraint
con2 <- cons[13:14] # load the car/no car constraint
con3 <- cons[15:24] # socio-economic class

cat_labs <- names(cons) # category names, from correct from cons.R

# set-up aggregate values - column for each category
source("../data/CakeMap/categorise.R") # this script must be customised to input data

# check constraint totals - should be true
sum(ind_cat[,1:ncol(con1)]) == nrow(ind) # is the number in each category correct?
sum(ind_cat[,ncol(con1)+1:ncol(con2)]) == nrow(ind) 

# create 2D weight matrix (individuals, areas)
weights <- array(NA, dim=c(nrow(ind),nrow(cons))) 

# convert survey data into aggregates to compare with census (3D matix)
ind_agg <- matrix(colSums(ind_cat), nrow(cons), ncol(cons), byrow = T)
ind_agg[1:5,1:10] # look at what we've created - n. individuals replicated throughout

############## The IPF part #############
# make sure you have this package
library(ipfp)
cons <- apply(cons, 2, as.numeric)
ind_catt <- t(ind_cat)
# set up initial vector as a load of 1s
x0 <- rep(1, nrow(ind))
# you can use x0 as a way to start from the original survey weights
# as it just has to be a numeric initial vector (length ncol)
# this might be useful if you have a small number of constraints but
# if you have many the effect of the IPF will tend to drown them out

# now loop over the zones and save ipfp results to weights
for(i in 1:ncol(weights)){
  weights[,i] <- ipfp(cons[i,], ind_catt, x0, maxit = 20)
}

### Convert back to aggregates for testing
for (i in 1:nrow(cons)){ # convert con1 weights back into aggregates
  ind_agg[i,]   <- colSums(ind_cat * weights[,i])
}

# test results for first row (not necessary for model)
# you could iterate over this to test each zone
ind_agg[1,1:15] - cons[1,1:15] # should be zero for final column - last constraint
# which should remind us that IPF works to an order - so the last constraint is
# fitted perfectly. This might matter if you think other constraints should be fitted perfectly...

# Test correlations between original constraints and new aggregates
cor(as.numeric(ind_agg), as.numeric(cons)) # fit between contraints and estimate
# Might be worth then testing zone by zone
# save the results into corr_by_zone_res
corr_by_zone_res <- NULL
for (i in 1:nrow(cons)){ 
  corr_by_zone_res[i] <- cor(as.numeric(ind_agg[i,]), as.numeric(cons[i,]))
}
# look at range of zone by zone correlations
range(corr_by_zone_res)

# at this point RL wants to integerise to create a spatial microdataset of whole 'units'
# But we don't have to - for many applications we may want to keep all the survey units (people or households)
# with their fractional weights to avoid losing information. It also helps if we're interested in distributional
# statistics for each area.

# to do this simply reshape the weights so that each row is 1 individual per zone with weight

# make weights a dataframe first 
weights_df <- as.data.frame(weights)
# reshape it (needs 'stats' package)
weights_l <- reshape(weights_df, direction = "long", varying = names(weights_df), sep = "")
# fix the variable names after doing this
names(weights_l)[names(weights_l) == "time"] <- "zone" # why can't this work directly on the name?!
names(weights_l)[names(weights_l) == "V"] <- "weight"
names(weights_l)

# now do the internal join to match the indivudal level data to the long form file
# create id variable in ind (assumes final order = same!)
ind$id <- 1:nrow(ind)
# make sure you have this package
library(dplyr)
final_micro <- inner_join(weights_l,ind, by = "id")

# check
names(final_micro)
nrow(final_micro)
# notice how many fewer rows there are than in the original CakeMap.R version 
# - we have not needed to duplicate individuals as we are keeping the fractional weights

# now let's add the geonames
# get geo names
geonames <- read.csv("../data/CakeMap/cars-raw.csv")
geonames_df <- as.data.frame(geonames[3:126,2])
# create a zoneid
geonames_df$zone <- 1:nrow(geonames_df)
names(geonames_df)[1] <- "zone_name"

final_micro_geo <- inner_join(geonames_df,final_micro, by = "zone")

# so now we have our final long form synthetic fractional weights microdata table
# with n * z rows where n = nrow(ind) and z = nrow(cons).
# This is in contrast to the integerised version where we would have the 
# sum of npop(zi) where npop(zi) is the population for each zone
# This would be a much larger file...

# Test the results!!

# change nssec8 to numeric
final_micro_geo$NSSEC8n <- as.numeric(final_micro_geo$NSSEC8)
summary(final_micro_geo$NSSEC8n)

# careful, 97 = unset
final_micro_geo$NSSEC8n[final_micro_geo$NSSEC8n > 10] <- NA
summary(final_micro_geo$NSSEC8n)
# use na.rm to ignore them
# overall mean
mean(final_micro_geo$NSSEC8n, na.rm = TRUE)
# weighted mean - to show the difference
weighted.mean(final_micro_geo$NSSEC8n, w = final_micro_geo$weight, na.rm = TRUE)

# mean by zone - this fails claiming x and w are different lengths, why?
aggregate(final_micro_geo$NSSEC8n, by= list(final_micro_geo$zone), FUN = weighted.mean, w = final_micro_geo$weight, na.rm = TRUE)

# so for now, let's save the file out and do the stats in STATA!!
write.csv(final_micro_geo, file = "final_micro_fractional_cakes_geo.csv", na = ".")

# now read the summary of cakes by zone (created in STATA) back in
cakes_by_zone <- read.csv("cakes_geo.csv")

# and do the R mapping thing...
# to do