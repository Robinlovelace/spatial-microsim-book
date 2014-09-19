# Create cakes object

intall <- ints <- as.list(1:nrow(cons)) # Names of integer indices (ints), and integer populations (intall) in ordered list
intagg <- cons * 0 # Aggregate area stats - set to 0 to avoid confusion
cakes <- data.frame(avCake = rep(0,nrow(cons)), sdCake = rep(0,nrow(cons)))

set.seed(0) # Include this line to ensure repeatable results

# Sample individuals based on their proportional probabilities
for (i in 1:nrow(cons)){
  ints[[i]] <- sample(which(weights[,i] >= 0), size = sum(con1[i,]), 
    prob=weights[,i], replace = T) 
  intall[[i]] <- ind[ints[[i]],] # Pulls all other data from index
  source("data/CakeMap/area-cat.R") # save the aggregate data
  intagg[i,] <- colSums(area.cat) 
  cakes$avCake[i] <- mean(intall[[i]]$avnumcakes)
  cakes$sdCake[i] <- sd(intall[[i]]$avnumcakes)
}
