# Testing the GREGWT package
install.packages("~/other-repos/mikrosim//GREGWT_1.4.tar.gz", repos=NULL)

library(GREGWT)
con_age <- read.csv("data/SimpleWorld/age.csv")
con_sex <- read.csv("data/SimpleWorld/sex.csv")
ind <- read.csv("data/SimpleWorld/ind-full.csv") 

ind$age <- cut(ind$age, b = c(-Inf, 49, Inf), l = c("a0.49", "a.50."))

cat_age <- model.matrix(~ ind$age - 1)
cat_sex <- model.matrix(~ ind$sex -1)[, c(2,1)]
  
  
# Age
a0.49 <- vector(length=dim(ind)[1])
a0.49[ind$age<50] = 1
a.50 <- vector(length=dim(ind)[1])
a.50[ind$age>=50] = 1
# Sex, we only need one
m <- vector(length=dim(ind)[1])
m[ind$sex == "m"] = 1
# prepare X
X <- data.frame(
  "a0.49" = a0.49,
  "a.50" = a.50,
  "m" = m)

# Initial weights
# Not such a good idea to start with a vector of ones as initial weights!
age <- con_age
sex <- con_sex

dx <- vector(length=dim(X)[1]) + 1
# prepare a data.frame to store the result
Result = data.frame(
  area=vector(length=dim(age)[1]),
  income=vector(length=dim(age)[1]),
  cap.income=vector(length=dim(age)[1]))
# now we loop through all areas
for(area in seq(dim(age)[1])){
  # True population totals for this area
  Tx <- data.frame(
    "a0.49" = age[area, 1],
    "a.50" = age[area, 2],
    "m" = sex[area, 1])
  # Get new weights with GREGWT
  Weights.GREGWT = GREGWT(X, dx, Tx, bounds=c(0,Inf))
  cat("area:", area, "\n")
  # Estimate income
  sum.income <- sum(Weights.GREGWT$Final.Weights * ind$income)
  cap.income <- sum(Weights.GREGWT$Final.Weights * ind$income / sum(Weights.GREGWT$Final.Weights))
  Result[area,] <- c(area, sum.income, cap.income)}
# view the results
View(Result)
  


