# Script to process car ownership

car <- read.csv("cakeMap/cars-raw.csv", skip = 2)
head(car)

write.csv(car[6:7], file="cakeMap/con2.csv", row.names=F)
