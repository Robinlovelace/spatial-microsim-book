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
cons <- cons[sample(3, size = 1000, replace = T),]

weights <- matrix(data = NA, nrow = nrow(ind), ncol = nrow(cons))

ind_ctt <- t(ind_cat)
x0 <- rep(1, nrow(ind))

f1 <- function(){
  for(i in 1:nrow(cons)){
    weights[,i] <- ipfp(cons[i,], ind_ctt, x0)
  }
}

f2 <- function(){
  weights_apply <- apply(cons, 1, function(x) ipfp(x, ind_ctt, x0))
}

library(parallel)
detectCores() # how many cores on the system?
cl <- makeCluster(getOption("cl.cores", 4)) # make the cluster
clusterExport(cl,c("ipfp","ind_ctt", "x0")) # packages and objects to cluster
f3 <- function(cl){
  weights_apply <- parApply(cl = cl, cons, 1, function(x) ipfp(x, ind_ctt, x0))
}

library(microbenchmark)
microbenchmark(f1(), f2(), f3(cl), times = 20 )

stopCluster(cl) # stop the cluster