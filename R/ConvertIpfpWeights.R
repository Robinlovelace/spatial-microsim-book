# first execute the CakeMap.R
weight_ipfp <- array(0, dim=dim(weight_init), dimnames = dimnames(weight_init))

for (indiv in 1:nrow(ind)){
  temp <- weight_ipfp[,c(as.character(ind[indiv,1])),c(as.character(ind[indiv,2])),c(as.character(ind[indiv,3])),c(as.character(ind[indiv,4])),c(as.character(ind[indiv,5]))] 
  weight_ipfp[,c(as.character(ind[indiv,1])),c(as.character(ind[indiv,2])),c(as.character(ind[indiv,3])),c(as.character(ind[indiv,4])),c(as.character(ind[indiv,5]))] <- temp +weights[indiv,] 
}