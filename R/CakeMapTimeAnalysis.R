# comparison of times to perform ipfp and mipfp

Neval = 1

times <- array(0,dim=c(2,Neval))

for (i in 1:Neval){
  print(i)
  times[1,i] <- system.time(apply(cons_prop, 1, function(x) ipfp(x, ind_catt, x0, tol = 1e-12)))[1]

  times[2,i] <- system.time(Ipfp( weight_init, descript, target, print = FALSE, tol=1e-12))[1]
}

# with a problem of this size, ipfp seems to be better
# we want to see how the times evolves if the individuals available are more

ind_catt2 <- cbind(ind_catt, ind_catt, ind_catt)
x02 <- cbind(x0,x0,x0)
weight_init2 <- weight_init * 3


minInd <- 200
maxInd <- 2000
pas <- 100

times2 <- array(0,dim=c(3,ceiling((maxInd-minInd)/pas)+1))
i=1

for (indiv in seq(minInd,maxInd,pas)){
  print(indiv)
  times2[1,i] <- indiv
  times2[2,i] <- system.time(apply(cons_prop, 1, function(x) ipfp(x, ind_catt2[,1:indiv], x02[1:indiv], tol = 1e-12)))[1]
  
  times2[3,i] <- system.time(Ipfp( weight_init*indiv/916, descript, target, print = FALSE, tol=1e-12))[1]
  i=i+1
}

plot(times2[1,],times2[2,],pch=c(1),ylim=c(min(times2[2,])-1,max(times2[2,])+1), main= "Time to generate a weight matrix \n with tol=1e-12 ",xlab="Number of invididuals in the microdata",ylab="Time")
par(new=TRUE)
plot(times2[1,],times2[3,],pch=c(3),ylim=c(min(times2[2,])-1,max(times2[2,])+1),axes=F,ann=F)
legend("topleft",c("ipfp","mipfp"),pch = c(1,3))
