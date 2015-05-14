# Testing the loglin implementation of ipf
load("cache-data-prep.RData")

# IPFP results
library(ipfp) # load ipfp library after install.packages("ipfp")
cons <- apply(cons, 2, as.numeric) # to 1d numeric data type
ipfp(cons[1,], t(ind_cat), x0 = rep(1, nrow(ind))) # run IPF

# now replicate with loglin
example(loglin)
?loglin
HairEyeColor
fm <- loglin(table = HairEyeColor, margin = list(c(1, 2), c(1, 3), c(2, 3)), fit = T)
fm
loglin(table = cons[1,], margin = ind_agg)


# table of values to fit
indc <- table(ind[, c(2, 3)])
fm2 <- loglin(indc, list(c(1,2)), fit = T)
fm2 <- loglin(indc, list(c(1,2)), start = cons, fit = T, param = T)
