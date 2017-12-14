#library(devtools)
devtools::install_github("emunozh/GREGWT")
library('GREGWT')

# Load the data from csv files stored under ../data
age = read.csv("../data/SimpleWorld/age.csv")
sex = read.csv("../data/SimpleWorld/sex.csv")
ind = read.csv("../data/SimpleWorld/ind-full.csv")
# Make categories for age
ind$age <- cut(ind$age, breaks=c(0,49,Inf), labels = c("a0.49", "a.50."))
# Add initial weights to survey
ind$w <- vector(mode = "numeric", length=dim(ind)[1]) + 1

# prepare simulation data using GREGWT::prepareData
data_in <- prepareData(cbind(age, sex), ind, census_area_id = F, breaks = c(2))

# prepare a data.frame to store the result
fweights <- NULL
Result <- as.data.frame(matrix(NA, ncol=3, nrow=dim(age)[1]))
names(Result) <- c("area", "income", "cap.income")

# now we loop through all areas
for(area in seq(dim(age)[1])){
    gregwt = GREGWT(data_in, area_code = area)
    fw <- gregwt$final_weights
    fweights <- c(fweights, fw)
    ## Estimate income
    sum.income <- sum(fw * ind$income)
    cap.income <- sum(fw * ind$income / sum(fw))
    Result[area,] <- c(area, sum.income, cap.income)
}

fweights <- matrix(fweights, nrow = nrow(ind))
fweights

#ind_agg <- t(apply(fweights, 2, function(x) colSums(x * ind_cat)))
#ind_agg
