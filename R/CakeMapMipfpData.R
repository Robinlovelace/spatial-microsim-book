# Loading the CakeMap data 
# Changing the categories'names to have the same names in ind and cons


# Loading the data: Ensure R is in the right working directory 
ind <- read.csv("data/CakeMap/ind.csv")
cons <- read.csv("data/CakeMap/cons.csv")

# Load constraints separately - normally this would be first stage
con1 <- cons[1:12] # load the age/sex constraint
con2 <- cons[13:14] # load the car/no car constraint
con3 <- cons[15:24] # socio-economic class

# Rename the categories in "ind" to correspond to the one of cons
ind$Car <- sapply(ind$Car, FUN = switch, "Car", "NoCar")
ind$Sex <- sapply(ind$Sex, FUN = switch, "m", "f")
ind$NSSEC8 <- as.factor(ind$NSSEC8)
levels(ind$NSSEC8) <- colnames(con3)
ind$ageband4 <- gsub(pattern = "-", replacement = "_", x = ind$ageband4)

