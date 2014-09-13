############################################
#### From the spatial-microsim-book project  
#### https://github.com/Robinlovelace/spatial-microsim-book
############################################

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
x0 <- rep(1, nrow(ind))
weights <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, 20))

### Convert back to aggregates
for (i in 1:nrow(cons)){ # convert con1 weights back into aggregates
  ind_agg[i,]   <- colSums(ind_cat * weights[,i])}
# test results for first row (not necessary for model)
ind_agg[1,1:15] - cons[1,1:15] # should be zero for final column - last constraint
cor(as.numeric(ind_agg), as.numeric(cons)) # fit between contraints and estimate

# now integerise if integer results are required (uncomment one of the lines below)
# source("data/cakeMap/pp-integerise.R") # creates integer output (intall) and cakes
# source("data/cakeMap/TRS-integerise.R") # the TRS strategy

# Benchmarking
microbenchmark(source("CakeMap.R"), times = 1) # 2.05 s
# How long does this operation take in pure R?
old <- setwd("~/repos/smsim-course/")
microbenchmark(source("cMap.R"), times = 1) # 76.72 s
setwd(old)
