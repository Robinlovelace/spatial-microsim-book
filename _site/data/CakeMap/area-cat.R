## runs with integerisation code - produces categorised output with per area loop

# create new age/sex variable
AS <- paste0(intall[[i]]$Sex, intall[[i]]$ageband4)
unique(AS)

# matrix for constraint 1 - age/sex
m1 <- model.matrix(~AS-1)

# matrix for con2 (car ownership)
intall[[i]]$Car <- as.character(intall[[i]]$Car)
m2 <- model.matrix(~intall[[i]]$Car-1)

# matrix for con3 (nssec)
intall[[i]]$NSSEC8 <- as.character(intall[[i]]$NSSEC8)
m3 <- model.matrix(~intall[[i]]$NSSEC8-1)

summary(intall[[i]]$NCakes)
levels(ind$NCakes)
intall[[i]]$avnumcakes <- 1
intall[[i]]$avnumcakes[intall[[i]]$NCakes == levels(ind$NCakes)[1]] <- 0.5
intall[[i]]$avnumcakes[intall[[i]]$NCakes == levels(ind$NCakes)[2]] <- 1.5
intall[[i]]$avnumcakes[intall[[i]]$NCakes == levels(ind$NCakes)[3]] <- 4
intall[[i]]$avnumcakes[intall[[i]]$NCakes == levels(ind$NCakes)[4]] <- 8
intall[[i]]$avnumcakes[intall[[i]]$NCakes == levels(ind$NCakes)[5]] <- 0.1
summary(intall[[i]]$avnumcakes[])

# Polishing up
area.cat <- data.frame(cbind(m1, m2, m3))
names(ind_cat) <- cat_labs