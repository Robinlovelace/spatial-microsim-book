x <- c(2,3,4)
mean(x)

# here is a graph
plot(x)

xArray <- array(NA, dim = c(3,3))
xMatrix <- matrix(NA, nrow = 3, ncol = 3)
identical(xArray, xMatrix)

for(i in 1:ncol(weights)){
  weights[,i] <- ipfp(cons[i,], ind_catt, x0, maxit = 20)
}

weights <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, maxit = 20))
  
  