# converts numeric variables into categorical variables
# Create 0/1 counts from survey data

# create new age/sex variable
AS <- paste0(ind$Sex, ind$ageband4)
unique(AS)

# matrix for constraint 1 - age/sex
m1 <- model.matrix(~AS-1)
head(cons)
head(m1)
colnames(m1) <- names(cons)[1:12]
head(m1)
summary(rowSums(m1))

# matrix for con2 (car ownership)
ind$Car <- as.character(ind$Car)
m2 <- model.matrix(~ind$Car-1)
head(m2)
summary(m2)

# matrix for con3 (nssec)
ind$NSSEC8 <- as.character(ind$NSSEC8)
m3 <- model.matrix(~ind$NSSEC8-1)
head(m3)
names(cons)

# Polishing up
ind_cat <- data.frame(cbind(m1, m2, m3))
rm(m1, m2, m3)
names(ind_cat) <- cat_labs
head(ind_cat)
