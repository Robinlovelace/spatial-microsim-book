# Loading the aggregate dataset, saving as all.msim
getwd() # should be in the smsim-course folder
con1 <- read.csv("data/cakeMap/con1.csv") # age/sex variable
con2 <- read.csv("data/cakeMap/con2.csv") # no car / car
con3 <- read.csv("data/cakeMap/con3.csv") # ns-sec
names(con1)
names(con2)
names(con3)

con2 <- data.frame(cbind(con2[,1] - con2[,2], con2[,2]))
names(con2) <- c("Car", "NoCar")
head(con2)

sum(con1); sum(con2); sum(con3)
c(sum(con1), sum(con2), sum(con3)) / sum(con1) # how much the values deviate from expected

con.pop <- rowSums(con1) 
con1 <- round(con1 * con.pop / rowSums(con1))
con2 <- round(con2 * con.pop / rowSums(con2)) 
con3 <- round(con3 * con.pop / rowSums(con3))

sum(con1); sum(con2); sum(con3); # all the numbers should be equal - this is close enough!

# bind all the data frames together
all.msim <- cbind(con1 
                  ,con2
                  ,con3
                  )

which(all.msim == 0) 
range(all.msim) # range of values - there are no zeros
mean(con.pop) # average number of individuals in each zone

# in case there are zeros, set just above 1 to avoid subsequent problems
con1[con1 == 0] <- con2[con2 == 0] <- con3[con3 == 0] <- 0.0001   
# previous step avoids zero values (aren't any in this case...)

head(all.msim)

category.labels <- names(all.msim) # define the category variables we're working with

write.csv(all.msim, "data/cakeMap/cons.csv", row.names=F)

