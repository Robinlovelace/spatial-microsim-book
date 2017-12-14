library(mipfp)


source("code/CakeMapMipfpData.R")


# Initial weight matrix
weight_init_onezone <- table(ind)
# Check order of the variables
dimnames(weight_init_onezone) 

#########################################
# All zones together
#########################################
# Repeat the initial matrix n_zone times
init_cells <- rep(weight_init_onezone, each = nrow(cons))

# Define the names
names <- c(list(rownames(cons)),as.list(dimnames(weight_init_onezone)))

# Structure the data
weight_init <- array(init_cells, dim = 
                       c(nrow(cons),dim(weight_init_onezone)),
                     dimnames = names)

###########################################
# Check constraint's totals
###########################################

# check the totals per zone
table(rowSums(con2)==rowSums(con1))
table(rowSums(con3)==rowSums(con1))
table(rowSums(con2)==rowSums(con3))

# 1 and 2 are the same, 3 is different

# Observe the global total
sum(con1)
sum(con2)
sum(con3)
# 1 and 2 are the same, 3 is different

########################################
# convert the constraint 1 to be readable for mipfp
########################################

source("code/CakeMapMipfpCon1Convert.R")

########################################
# To correctly perform the Ipfp process, 
# we have to use coherent constraints, 
# with same marginals per zone.
# Since NSSEC contains less individuals and this could be due by the 
# possibily of having "NA", we consider con1 and con2 as example.
con3_prop <- con3*rowSums(con2)/rowSums(con3)

# Check the new marginals per zone
table(rowSums(con2)==rowSums(con3_prop))
# This is now ok

# Perform the Ipfp function
target <- list(con1_convert,as.matrix(con2),as.matrix(con3_prop))
descript <- list(c(1,4,6), c(1,3),c(1,5))



weight_mipfp <- Ipfp( weight_init, descript, target, 
                      print = TRUE,tol=1e-12)
##########################################
# Quality of this IPF
##########################################
# con1
max(abs(con1_convert-apply(weight_mipfp$x.hat,c(1,4,6),sum)))

# con2
max(abs(con2-apply(weight_mipfp$x.hat,c(1,3),sum)))

# con3
max(abs(con3_prop-apply(weight_mipfp$x.hat,c(1,5),sum)))

# con3 is well fitted for all zones, but con1 and 
# con2 have some municipalities with big errors


################################################
# Convert ipfp result for comparison 
################################################
# first execute the CakeMap.R
weight_ipfp <- array(0, dim=dim(weight_init), dimnames = dimnames(weight_init))

for (indiv in 1:nrow(ind)){
  temp <- weight_ipfp[,c(as.character(ind[indiv,1])),c(as.character(ind[indiv,2])),c(as.character(ind[indiv,3])),c(as.character(ind[indiv,4])),c(as.character(ind[indiv,5]))] 
  weight_ipfp[,c(as.character(ind[indiv,1])),c(as.character(ind[indiv,2])),c(as.character(ind[indiv,3])),c(as.character(ind[indiv,4])),c(as.character(ind[indiv,5]))] <- temp +weights[indiv,] 
}

# compare result;

which.max(abs(weight_ipfp-weight_mipfp$x.hat),ind)
sum(weight_ipfp)
sum(weight_mipfp$x.hat)

plot(weight_ipfp,weight_mipfp$x.hat)
max(apply(weight_mipfp$x.hat,1,sum)-apply(weight_ipfp,1,sum))
# The sum of ipfp is the one of the third constraint... 
# This is due to the order of the constraints
# Indeed, if we change the order of the constraints and re-calculate the ipfp:

cons <- cons[,c(15:24,1:14)]
ind_cat <- ind_cat[,c(15:24,1:14)]


# Iterative proportional fitting (IPF) stage
library(ipfp) # load the ipfp package -may need install.packages("ipfp")
cons <- apply(cons, 2, as.numeric) # convert the constraints to 'numeric'
ind_catt <- t(ind_cat) # transpose the dummy variables for ipfp
x0 <- rep(1, nrow(ind)) # set the initial weights
weights <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, maxit = 20))

# And the sum is now the same and the results also
sum(weights)


################################################
# Convert ipfp result for comparison 
################################################

weight_ipfp <- array(0, dim=dim(weight_init), dimnames = dimnames(weight_init))

for (indiv in 1:nrow(ind)){
  temp <- weight_ipfp[,c(as.character(ind[indiv,1])),c(as.character(ind[indiv,2])),c(as.character(ind[indiv,3])),c(as.character(ind[indiv,4])),c(as.character(ind[indiv,5]))] 
  weight_ipfp[,c(as.character(ind[indiv,1])),c(as.character(ind[indiv,2])),c(as.character(ind[indiv,3])),c(as.character(ind[indiv,4])),c(as.character(ind[indiv,5]))] <- temp +weights[indiv,] 
}


sum(weight_ipfp-weight_mipfp$x.hat)
