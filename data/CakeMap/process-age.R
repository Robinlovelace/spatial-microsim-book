# Converting the data into a suitable form
# We need the age to be classified as follows:
# 16 to 24, 25 to 34, 35 to 44, 45 to 54, 55 to 64, 65 to 74, 75 and over
# We will also categorise by male and female

# setwd("cakeMap/") # navigate into cakeMap directory 
# (try typing 'getwd() or Session > Set Working Directory if this does not work)

ageNames <- c("m16_24", "m25_34", "m35_44", "m45_54", "m55_64", "m65_74",
  "f16_24", "f25_34", "f35_44", "f45_54", "f55_64", "f65_74") # the output we want

age <- read.csv("age-sex-raw.csv")
names(age)
age[1:3,6] # note that the first 2 rows are not needed
rawNames <- age[1,]
age <- age[-c(1,2),]
class(age[,6]) # due to mix of character and numeric data, it's loaded factors

age <- read.csv("age-sex-raw.csv", skip=2) # reload data only selecting numbers
head(age[1:7])
class(age[,6]) # now its integer
head(age)
plot(colSums(age[6:ncol(age)]))

# first category: males 16 - 24
sel <- seq(6, (24-16) * 2 + 6, by = 2)
rawNames[sel] # double check we have the correct categories
assign(x = ageNames[1], value = rowSums(age[,sel]))

# second category: males 25 - 34
selt <- seq(max(sel) + 2, (34 - 25) * 2 + max(sel) + 2, by = 2)
rawNames[selt] # double check we have the correct categories

con1 <- data.frame(matrix(nrow = nrow(age), ncol = length(ageNames)))
names(con1) <- ageNames
con1[1] <- rowSums(age[sel])

# automating the process
for(i in 2:6){
  sel <- seq(max(sel) + 2, 9 * 2 + max(sel) + 2, by = 2)
  print(rawNames[sel]) # test it works
  con1[i] <- rowSums(age[sel], na.rm=T)
}

# first category: females 16 - 24
sel <- seq(7, (24-16) * 2 + 7, by = 2)
rawNames[sel] # double check we have the correct categories
con1[7] <- rowSums(age[sel])
names(con1)
for(i in 2:6){
  sel <- seq(max(sel) + 2, 9 * 2 + max(sel) + 2, by = 2)
  print(rawNames[sel]) # test it works
  con1[i+6] <- rowSums(age[sel], na.rm=T)
}

plot(colSums(con1))
write.csv(con1, "con1.csv", row.names = F)
