# Testing the GREGWT package
# install.packages("~/other-repos/mikrosim//GREGWT_1.4.tar.gz", repos=NULL) # download from https://github.com/emunozh/mikrosim/

library(GREGWT)
con_age <- read.csv("data/SimpleWorld/age.csv")
con_sex <- read.csv("data/SimpleWorld/sex.csv")
ind <- read.csv("data/SimpleWorld/ind-full.csv") 

ind$age <- cut(ind$age, b = c(-Inf, 49, Inf), l = c("a0.49", "a.50."))

cat_age <- model.matrix(~ ind$age - 1)
cat_sex <- model.matrix(~ ind$sex -1)[, c(2,1)]
ind_cat <- cbind(cat_age, cat_sex)
colnames(ind_cat) <- gsub("ind\\$(...)", "", colnames(ind_cat))
dx <- rep(1, nrow(ind_cat))
Tx <- cbind(cat_age, cat_sex)

res <- GREGWT(ind_cat[,1:3], dx, Tx = Tx[1,])
fw <- res$Final.Weights

# Estaban's code
# load the functions
library('GREGWT')

## Data ######
# Load the data from csv files stored under ./Data
age = read.csv("data/SimpleWorld/age.csv")
sex = read.csv("data/SimpleWorld/sex.csv")
ind = read.csv("data/SimpleWorld/ind-full.csv")
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
dx <- vector(length=dim(X)[1]) + 1

# prepare a data.frame to store the result
fweights <- NULL
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
  fw <- Weights.GREGWT$Final.Weights
  # Estimate income
  fweights <- c(fweights, fw)
  sum.income <- sum(Weights.GREGWT$Final.Weights * ind$income)
  cap.income <- sum(Weights.GREGWT$Final.Weights * ind$income / sum(Weights.GREGWT$Final.Weights))
  Result[area,] <- c(area, sum.income, cap.income)}

fweights <- matrix(fweights, nrow = nrow(ind))

ind_agg <- t(apply(fweights, 2, function(x) colSums(x * ind_cat)))
ind_agg
