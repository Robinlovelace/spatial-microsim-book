# optim test CakeMap

source("code/CakeMap.R") # load cakemap data
indu <- unique(ind_cat)
rns <- as.integer(row.names(indu))

library(dplyr)
ind_cat$p <- apply(ind_cat, 1, paste0, collapse = "")
umat <- count(ind_cat, p, sort = TRUE)$n

ind_num <- apply(indu, 2, function(x) x * umat) # ind_num: unique row numbers to optimise
