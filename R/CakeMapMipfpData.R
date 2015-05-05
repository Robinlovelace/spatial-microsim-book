# Loading the CakeMap data 
# Changing the categories'names to have the same names in ind and cons


# Loading the data: Ensure R is in the right working directory 
ind <- read.csv("data/CakeMap/ind.csv")
cons <- read.csv("data/CakeMap/cons.csv")

# to just paste sex and age
colnames(cons) <- gsub("_", "-", colnames(cons))

# Load constraints separately - normally this would be first stage
con1 <- cons[1:12] # load the age/sex constraint
con2 <- cons[13:14] # load the car/no car constraint
con3 <- cons[15:24] # socio-economic class

# Rename the categories in "ind" to correspond to the one of cons
ind$Car <- gsub(1,"Car",ind$Car)
ind$Car <- gsub(2,"NoCar",ind$Car)
ind$Sex <- gsub(1,"m",ind$Sex)
ind$Sex <- gsub(2,"f",ind$Sex)
ind$NSSEC8 <- as.factor(ind$NSSEC8)
levels(ind$NSSEC8) <- colnames(con3)

