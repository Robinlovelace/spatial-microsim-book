# Script 'integerising' CakeMap weights, generating, exploring spatial microdata

source("code/functions.R") # functions for spatial microsimulation, inc. int_trs

ints <- unlist(apply(weights, 2, function(x) int_expand_vector(int_trs(x)))) # generate integerised result
ints_df <- data.frame(id = ints, zone = rep(1:nrow(cons), round(colSums(weights))))
ind$id <- 1:nrow(ind) # assign each individual an id

# Create spatial microdata, by joining the ids with associated attributes
ints_df <- inner_join(ints_df, ind) # commented out to increase run-times

# Exploration of individual-level variability in class by zone
class(ints_df$NSSEC8) # what class is the class variable?
ints_df$NSSEC <- as.numeric(ints_df$NSSEC8) # convert to numeric class
ints_df$NSSEC[ ints_df$NSSEC > 10] <- NA # dealing with NA data
sd_nssec <- aggregate(ints_df$NSSEC, by = list(ints_df$zone), FUN = sd, na.rm = TRUE)
which.max(sd_nssec$x) # which zone has the greatest variability in NS-SEC groups
