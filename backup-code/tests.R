con_age <- read.csv("data/SimpleWorld/age.csv")
con_sex <- read.csv("data/SimpleWorld/sex.csv")
ind <- read.csv("data/SimpleWorld/ind.csv")

(ind$age <- cut(ind$age, breaks = c(0, 49, 120), labels = c("a0_49", "a50+")))

names(con_age) <- levels(ind$age) # rename aggregate variables
h
# make the number of constraints larger - to see benefit of parallel processing
cons <- cbind(con_age, con_sex) 

cat_age <- model.matrix(~ ind$age - 1)
cat_sex <- model.matrix(~ ind$sex - 1)[, c(2, 1)]
(ind_cat <- cbind(cat_age, cat_sex)) # combine flat representations of the data

cons <- apply(cons, 2, as.numeric) # convert matrix to numeric data type
# cons <- cons[sample(3, size = 500, replace = T),]

weights <- matrix(data = NA, nrow = nrow(ind), ncol = nrow(cons))

ind_catt <- t(ind_cat)
x0 <- rep(1, nrow(ind))

weights <- apply(cons, MARGIN = 1, FUN =  function(x) ipfp(as.numeric(x), ind_catt, x0, tol = 1, maxit = 20))

# Tests of parallel implementation of ipf
library(parallel)

detectCores()
cl <- makeCluster(getOption("cl.cores", 4))
cl <- clusterExport(cl, varlist = c("ipfp", "ind_cat", "ind"))

parApply(cons, MARGIN = 1, FUN =  function(x) ipfp(as.numeric(x), t(ind_cat), x0 = rep(1,nrow(ind))))


xArray <- array(NA, dim = c(3,3))
xMatrix <- matrix(NA, nrow = 3, ncol = 3)
identical(xArray, xMatrix)

for(i in 1:ncol(weights)){
  weights[,i] <- ipfp(cons[i,], ind_catt, x0, maxit = 20)
}

# Demonstration of incorrect ipfp
weights1 <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, tol = 1, maxit = 20))
weights2 <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, 20))
  
  