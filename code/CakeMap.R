############################################
#### From the spatial-microsim-book project  
#### https://github.com/Robinlovelace/spatial-microsim-book
############################################

library(dplyr) # load dplyr package for joining datasets

# Loading the data: Ensure R is in the right working directory 
ind <- read.csv("data/CakeMap/ind.csv")
cons <- read.csv("data/CakeMap/cons.csv")

# Take a quick look at the data
head(ind)
head(cons)

# Load constraints separately - normally this would be first stage
con1 <- cons[1:12] # load the age/sex constraint
con2 <- cons[13:14] # load the car/no car constraint
con3 <- cons[15:24] # socio-economic class

cat_labs <- names(cons) # category names, from correct from cons.R

# Set-up aggregate values - column for each category
source("data/CakeMap/categorise.R") # script to create binary dummy variables
# Check constraint totals - should be true
sum(ind_cat[,1:ncol(con1)]) == nrow(ind) # is the number in each category correct?
sum(ind_cat[,ncol(con1)+1:ncol(con2)]) == nrow(ind) 

# Create 2D weight matrix (individuals, areas)
weights <- array(NA, dim=c(nrow(ind),nrow(cons))) 

# Convert survey data into aggregates to compare with census 
ind_agg <- matrix(colSums(ind_cat), nrow(cons), ncol(cons), byrow = T)

# Iterative proportional fitting (IPF) stage
library(ipfp) # load the ipfp package -may need install.packages("ipfp")
cons <- apply(cons, 2, as.numeric) # convert the constraints to 'numeric'
ind_catt <- t(ind_cat) # transpose the dummy variables for ipfp
x0 <- rep(1, nrow(ind)) # set the initial weights
weights <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, maxit = 20))

### Convert back to aggregates
ind_agg <- t(apply(weights, 2, function(x) colSums(x * ind_cat)))

# test results for first row (not necessary for model)
ind_agg[1,1:15] - cons[1,1:15] # should be zero or close to zero
cor(as.numeric(ind_agg), as.numeric(cons)) # fit between contraints and estimate

# Integerise if integer results are required - open code/CakeMapInt.R to see how
source("code/CakeMapInts.R")

# Benchmarking
# library(microbenchmark)
# microbenchmark(source("CakeMap.R"), times = 1) # 2.05 s
# # How long does this operation take in pure R?
# old <- setwd("~/repos/smsim-course/")
# microbenchmark(source("cMap.R"), times = 1) # 76.72 s
# setwd(old)