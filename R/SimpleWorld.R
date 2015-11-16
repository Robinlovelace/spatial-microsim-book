# SimpleWorld.R
# Raw code needed to run the SimpleWorld example
ind <- read.csv("data/SimpleWorld/ind.csv") 
class(ind) # verify the data type of the object
ind # print the individual-level data

con_age <- read.csv("data/SimpleWorld/age.csv")
con_sex <- read.csv("data/SimpleWorld/sex.csv")

# Convert age into a categorical variable with user-chosen labels
(ind$age <- cut(ind$age, breaks = c(0, 49, 120), labels = c("a0_49", "a50+")))
names(con_age) <- levels(ind$age) # rename aggregate variables
cons <- cbind(con_age, con_sex)

cat_age <- model.matrix(~ ind$age - 1)
cat_sex <- model.matrix(~ ind$sex - 1)[, c(2, 1)]
(ind_cat <- cbind(cat_age, cat_sex)) # combine flat representations of the data

colSums(ind_cat) # view the aggregated version of ind
ind_agg <- colSums(ind_cat) # save the result

rbind(cons[1,], ind_agg) # test compatibility between ind_agg and cons objects

weights <- matrix(data = NA, nrow = nrow(ind), ncol = nrow(cons))
dim(weights) # the dimension of the weight matrix: 5 rows by 3 columns

library(ipfp) # load the ipfp library after: install.packages("ipfp")
cons <- apply(cons, 2, as.numeric) # convert matrix to numeric data type
ind_catt <- t(ind_cat) # save transposed version of ind_cat
x0 <- rep(1, nrow(ind)) # save the initial vector
weights <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, maxit = 20))

source('R/functions.R')

set.seed(0)
int_pp(x = c(0.333, 0.667, 3))
int_pp(x = c(1.333, 1.333, 1.333))


# Method 2: using apply
ints <- unlist(apply(weights, 2, int_trs)) # generate integerised result
ints_df <- data.frame(id = ints, zone = rep(1:nrow(cons), colSums(weights)))

ind_full <- read.csv("data/SimpleWorld/ind-full.csv")
library(dplyr) # install.packages(dplyr) if not installed
ints_df <- inner_join(ints_df, ind_full)


## ------------------------------------------------------------------------
ints_df[ints_df$zone == 2, ]
