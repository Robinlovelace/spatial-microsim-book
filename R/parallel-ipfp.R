con_age <- read.csv("data/SimpleWorld/age.csv")
con_sex <- read.csv("data/SimpleWorld/sex.csv")
ind <- read.csv("data/SimpleWorld/ind.csv")

(ind$age <- cut(ind$age, breaks = c(0, 49, 120), labels = c("a0_49", "a50+")))

names(con_age) <- levels(ind$age) # rename aggregate variables

# make the number of constraints larger - to see benefit of parallel processing
cons <- cbind(con_age, con_sex) 

cat_age <- model.matrix(~ ind$age - 1)
cat_sex <- model.matrix(~ ind$sex - 1)[, c(2, 1)]
(ind_cat <- cbind(cat_age, cat_sex)) # combine flat representations of the data

library(ipfp) # load the ipfp library after: install.packages("ipfp")
cons <- apply(cons, 2, as.numeric) # convert matrix to numeric data type
cons <- cons[sample(3, size = 500, replace = T),]

weights <- matrix(data = NA, nrow = nrow(ind), ncol = nrow(cons))

ind_catt <- t(ind_cat)
x0 <- rep(1, nrow(ind))

# Tests of the speed of the for solution vs the apply solution
ipfp_for <- function(){
  for(i in 1:ncol(weights)){
    weights[,i] <- ipfp(cons[i,], t(ind_cat), x0 = rep(1, nrow(ind)))
  }
}

ipfp_apply <- function(){
  weights <- apply(cons, MARGIN = 1, FUN =  function(x) ipfp(as.numeric(x), t(ind_cat), x0 = rep(1,nrow(ind))))
}

ipfp_for20 <- function(){
  for(i in 1:ncol(weights)){
    weights[,i] <- ipfp(cons[i,], t(ind_cat), x0 = rep(1, nrow(ind)), maxit = 20)
  }
}

ipfp_apply20 <- function(){
  weights <- apply(cons, MARGIN = 1, FUN =  function(x) ipfp(as.numeric(x), t(ind_cat), x0 = rep(1,nrow(ind)), maxit = 20))
}

ipfp_foric <- function(){
  for(i in 1:ncol(weights)){
    weights[,i] <- ipfp(cons[i,], ind_catt, x0 = rep(1, nrow(ind)))
  }
}

ipfp_applyic <- function(){
  weights <- apply(cons, MARGIN = 1, FUN = function(x) ipfp(as.numeric(x), ind_catt, x0 = rep(1,nrow(ind))))
}

ipfp_for20icx <- function(){
  for(i in 1:ncol(weights)){
    weights[,i] <- ipfp(cons[i,], ind_catt, x0, maxit = 20)
  }
}

ipfp_apply20icx <- function(){
  weights <- apply(cons, MARGIN = 1, FUN =  function(x) ipfp(as.numeric(x), ind_catt, x0 , maxit = 20))
}
library(microbenchmark)
microbenchmark(ipfp_for(), ipfp_apply(), ipfp_for20(), ipfp_apply20(), ipfp_foric(), ipfp_applyic(), ipfp_for20icx(), ipfp_apply20icx(), times = 5)

library(parallel)
detectCores() # how many cores on the system?
cl <- makeCluster(getOption("cl.cores", 4)) # make the cluster
clusterExport(cl,c("ipfp","ind_catt", "x0")) # packages and objects to cluster



ind_catt <- t(ind_cat)

f3 <- function(cl){
  weights_apply <- parApply(cl = cl, cons, 1, function(x) ipfp(x, ind_catt, x0))
}

library(microbenchmark)
microbenchmark(ipfp_for, ipfp_apply, ipfp_for20, ipfp_apply20, ipfp_foric, ipfp_applyic, ipfp_for20icx, ipfp_apply20icx(), f3(cl), times = 3 )

stopCluster(cl) # stop the cluster