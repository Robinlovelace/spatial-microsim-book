## ---- include=FALSE------------------------------------------------------
# packages to allow 'knitting' the chapter to html
library(png)
library(grid)
source("code/functions.R")
source("code/SimpleWorld.R")

## ---- echo=FALSE---------------------------------------------------------
# TODO:
# Ensure text is compatible with new use of chapter title as 'population synthesis'
# Discuss population synthesis without an input microdataset, with reference to Bathelemy and Toint (2013)
# Consider splitting this section in 2: reweighting vs CO approaches

# Completed:
# Change integerisation section so it's part of IPF (RL)
# Add IPF theory from Cambridge handout.pdf (mostly done)
# update figure with expansion

## ---- echo=FALSE---------------------------------------------------------
# How representative each individual is of each zone is determined by their
# *weight* for that zone. If we have `nrow(cons)` zones and `nrow(ind)`
# individuals (3 and 5, respectively, in SimpleWorld) we will create
# 15 weights. Real world datasets (e.g. that presented in chapter xxx)
# could contain 10,000 individuals
# to be allocated to 500 zones, resulting in an unwieldy 5 million element
# weight matrix but we'll stick with the SimpleWorld dataset here for simplicity.
load("cache-data-prep.RData")

## ------------------------------------------------------------------------
# Create the weight matrix. 
# Note: relies on data from previous chapter.
weights <- matrix(data = 1, nrow = nrow(ind), ncol = nrow(cons))
dim(weights) # dimension of weight matrix: 5 rows by 3 columns

## ---- echo=FALSE---------------------------------------------------------
# is the function tidyr:@expand the same as expand here? will test.

## ---- fig.cap="Schematic of different approaches for the creation of spatial microdata encapsulating stochastic combinatorial optimisation and deterministic reweighting algorithms such as IPF. Note that integerisation and 'compression' steps make the results of the two approaches interchangeable, hence our use of the term 'reweighting algorithm' to cover all methods for generating spatial microdata.", echo=FALSE----
img <- readPNG("figures/co-vs-ipf-schema.png")
grid.raster(img)

## ------------------------------------------------------------------------
set.seed(1) # set the seed for reproducibility
sel <- sample(x = 5, size = 12, replace = T) # create selection
ind_z1 <- ind_orig[sel, ]
head(ind_z1, 3)

## ---- echo=FALSE---------------------------------------------------------
# TODO (RL): add Lovelace et al (2015) example when published above

## ---- echo=FALSE---------------------------------------------------------
# TODO (MD): add reference above
#(Dumont,2014) Jojo thesis and article given by Eric 

## ------------------------------------------------------------------------
# Create intuitive names for the totals
n_zone <- nrow(cons) # number of zones
n_ind <- nrow(ind) # number of individuals
n_age <-ncol(con_age) # number of categories of "age"
n_sex <-ncol(con_sex) # number of categories of "sex"

## ------------------------------------------------------------------------
# Create initial matrix of categorical counts from ind 
ind_agg0 <- t(apply(cons, 1, function(x) x^0 * ind_agg))
weights1 <- weights2 <- weights # create addition weight objects

## ---- echo=FALSE---------------------------------------------------------
# The long way of doing it 
# # Create initial matrix of categorical counts from ind
# ind_agg0 <- matrix(rep(ind_agg, nrow(cons)), nrow = nrow(cons), byrow = T)
# weights1 <- weights2 <- weights # create addition weight objects for IPFinR
# # Assign values to the previously created weight matrix
# for(j in 1:nrow(cons)){
# for(i in 1:ncol(con_age)){
# weights1[ind_cat[ , i ] == 1, j] <- con_age[j , i] / ind_agg0[j , i]
# }
# }

## ------------------------------------------------------------------------
# Assign values to the previously created weight matrix 
# to adapt to age constraint
for(j in 1:n_zone){
  for(i in 1:n_age){
weights1[ind_cat[, i] == 1, j] <- con_age[j, i] / ind_agg0[j, i]
    }
print(weights1)
  }

## ------------------------------------------------------------------------
# Create additional ind_agg objects
ind_agg2 <- ind_agg1 <- ind_agg0 * NA

# Assign values to the aggregated data after con 1
for(i in 1:n_zone){
  ind_agg1[i, ] <- colSums(ind_cat * weights1[, i])
}

## ------------------------------------------------------------------------
rowSums(ind_agg1[, 1:2]) # the simulated populations in each zone
rowSums(cons[, 1:2]) # the observed populations in each zone

## ------------------------------------------------------------------------
vec <- function(x) as.numeric(as.matrix(x))
cor(vec(ind_agg0), vec(cons))
cor(vec(ind_agg1), vec(cons))

## ------------------------------------------------------------------------
weights1[, 1]

## ------------------------------------------------------------------------
cons[1, ]

## ------------------------------------------------------------------------
for(j in 1:n_zone){
  for(i in 1:n_sex + n_age){
weights2[ind_cat[, i] == 1, j] <- weights1[ind_cat[, i] == 1, j] * cons[j , i] / ind_agg1[j, i]
    }
print(weights2)
  }

## ------------------------------------------------------------------------
weights2

## ------------------------------------------------------------------------
for(i in 1:n_zone){
ind_agg2[i, ] <- colSums(ind_cat  * weights2[, i])
}

## ----valit_plot1, echo=FALSE, fig.cap="Fit between observed and simulated values for age and sex categories (column facets) after constraining a first time by age and sex constraints (iterations 1.1 and 1.2, plot rows). The dotted line in each plot represents perfect fit between the simulated and observed cell values. The overall fit in each case would be found by combining the left and right-hand plots. Each symbol correspond to a category and each category has a couple (observed, simulated) for each zone."----
# Make data long it with tidyr
library(tidyr)
library(dplyr) # a package required by tidyr functions
x <- gather(cons, Category, Observed, a0_49:f)
y <- gather(as.data.frame(ind_agg1), cat, Simulated, a0_49:f)
z <- gather(as.data.frame(ind_agg2), cat, Simulated, a0_49:f)
# y$cat <- x$cat # to make categories identical (not needed)
df1 <- cbind(x,y)
df1$Constraint <- "1.1: Age"
df2 <- cbind(x, z)
df2$Constraint <- "1.2: Sex"
df <- rbind(df1, df2)
df$Variable <- "Age"
df$Variable[grep("[mf]", df$Category)] <- "Sex"
library(ggplot2)
qplot(Observed, Simulated, data = df, shape = Category, alpha = 0.5) +
  facet_grid(Constraint ~ Variable) +
  geom_abline(slope = 1, linetype = 3) +
  scale_alpha(guide = F) +
  scale_shape_manual(values = c(1,11,2,12)) +
  theme_bw()
# ggsave("figures/fit-obs-sim-simple-5.png")
# Attempt 2: do it with reshape2
# library(reshape2)
# melt(cons)

## ------------------------------------------------------------------------
library(ipfp) # load ipfp library after install.packages("ipfp")
cons <- apply(cons, 2, as.numeric) # to 1d numeric data type
ipfp(cons[1,], t(ind_cat), x0 = rep(1, n_ind)) # run IPF

## ---- echo=FALSE---------------------------------------------------------
# Attention, the TAE is the current matrix vs the target matrix
#            convergence is the current matrix vs the previous one
# if the constraints are not possible to respect, the convergence will be reach
# without fitting to the target (a little tol, but a big TAE)

## ---- eval=FALSE---------------------------------------------------------
## ipfp(cons[1,], t(ind_cat), rep(1, n_ind), maxit = 20, v = T)

## ------------------------------------------------------------------------
ind_catt <- t(ind_cat) # save transposed version of ind_cat

## ------------------------------------------------------------------------
x0 <- rep(1, n_ind) # save the initial vector

## ------------------------------------------------------------------------
weights_maxit_2 <- weights # create a copy of the weights object
for(i in 1:ncol(weights)){
  weights_maxit_2[,i] <- ipfp(cons[i,], ind_catt, x0, maxit = 2)
}

## ------------------------------------------------------------------------
weights <- apply(cons, MARGIN = 1, FUN = 
    function(x) ipfp(x, ind_catt, x0, maxit = 20))

## ---- echo=FALSE, eval=FALSE---------------------------------------------
## # Also discuss what happens when you get a huge dataset, from Stephen's dataset

## ------------------------------------------------------------------------
ind_agg <- t(apply(weights, 2, function(x) colSums(x * ind_cat)))
colnames(ind_agg) <- colnames(cons) # make the column names equal

## ------------------------------------------------------------------------
ind_agg
cons

## ------------------------------------------------------------------------
# Update ind_agg values, keeping col names (note '[]')
ind_agg[] <- t(apply(weights_maxit_2, MARGIN = 2, 
  FUN = function(x) colSums(x * ind_cat)))
ind_agg[1:2, 1:4]

## ---- echo=FALSE---------------------------------------------------------
# we have a new column with, at most, as many categories as the product of the number of categories for the variable age
# and 2 (Male or Female). However, in this case, we need to have the cross table of the age and the sex available to 
# proceed this way.

## ---- message=F----------------------------------------------------------
library(mipfp) # after install.packages("mipfp")

## ------------------------------------------------------------------------
sex <- c(Male = 23, Female = 27) # n. in each sex category

age <- c(Less18 = 16, Workage = 20, Senior = 14) # age bands

diploma <- c(Level1 = 20, Level2 = 18, Level3 = 6, Level4 = 6) 

## ------------------------------------------------------------------------
target <- list (sex, age, diploma)
descript <- list (1, 2, 3)
target

## ------------------------------------------------------------------------
names <- list (names(sex), names(age), names(diploma))
weight_init <- array (1, c(2,3,4), dimnames = names)
weight_init[, c("Less18"), c("Level3","Level4")] <- 0

## ------------------------------------------------------------------------
result <- Ipfp(weight_init, descript, target, iter = 50, 
               print = TRUE, tol = 1e-5)

## ------------------------------------------------------------------------
result$x.hat # print the result
sum(result$x.hat) # check the total number of persons

## ------------------------------------------------------------------------
# printing the resulting margins
result$check.margins

## ------------------------------------------------------------------------
# define the cross table
cross <- cbind(c(11,5,0,0), c(3,9,4,4), c(6,4,2,2))
rownames (cross) <- names (diploma)
colnames (cross) <- names(age)

# print the cross table
cross

## ------------------------------------------------------------------------
# check pertinence for diploma 
rowSums(cross)
diploma

# check pertinence for age 
colSums(cross)
age

## ------------------------------------------------------------------------
# defining the new target and associated descript
target <- list(sex, age, diploma, cross)
descript <- list(1, 2, 3, c(3,2))

# running the Ipfp function
result <- Ipfp(weight_init, descript, target, iter = 50, 
               print = TRUE, tol = 1e-5)

## ------------------------------------------------------------------------
int_pp <- function(x){
  # For generalisation purpose, x becomes a vector
  # This allow the function to work with matrix also
  xv <- as.vector(x)
  # Initialisation of the resulting vector
  xint <- rep(0, length(x))
  # Sample the individuals
  xs <- sample(length(x), size = round(sum(x)), prob = x, replace = T)
  # Aggregate the result into a weight vector
  xsumm <- summary(as.factor(xs))
  # To deal with empty category, we restructure
  topup <- as.numeric(names(xsumm))
  xint[topup] <- xsumm
  # For generalisation purpose, x becomes a matrix if necessary
  dim(xint) <- dim(x)
  xint
}

## ------------------------------------------------------------------------
set.seed(50)
xint1 <- int_pp(x = c(0.333, 0.667, 3))
xint1

xint2 <- int_pp(x = c(1.333, 1.333, 1.333))
xint2

## ------------------------------------------------------------------------
xint1 <- int_pp(x = c(0.333, 0.667, 3))
xint1

xint2 <- int_pp(x = c(1.333, 1.333, 1.333))
xint2

## ---- echo=FALSE---------------------------------------------------------
# (Dumont,2015): if we want to prove that with a larger dataset the distribution tends
# to the desired one:
# set.seed(0)
# hist(int_pp(x=rep(1.3333,100000)),main="100000 randomly draws with a uniform probability", xlab="Random numbers",ylab="Frequency")

## ------------------------------------------------------------------------
int_trs <- function(x){
  # For generalisation purpose, x becomes a vector
  # This allow the function to work with matrix also
  xv <- as.vector(x)
  xint <- floor(xv) # integer part of the weight
  r <- xv - xint # decimal part of the weight
  def <- round(sum(r)) # the deficit population
  # the weights be 'topped up' (+ 1 applied)
  topup <- sample(length(x), size = def, prob = r)
  xint[topup] <- xint[topup] + 1
  dim(xint) <- dim(x)
  dimnames(xint) <- dimnames(x)
  xint
}

## ------------------------------------------------------------------------
set.seed(50)
xint1 <- int_trs(x = c(0.333, 0.667, 3))
xint1

xint2 <- int_trs(x = c(1.333, 1.333, 1.333))
xint2

# Second time: 
xint1 <- int_trs(x = c(0.333, 0.667, 3))
xint1

xint2 <- int_trs(x = c(1.333, 1.333, 1.333))
xint2

## ------------------------------------------------------------------------
int_weight1 <- int_trs(weights[,1])

## ------------------------------------------------------------------------
weights[,1]
int_weight1 

## ------------------------------------------------------------------------
set.seed(42)
mipfp_int <- int_trs(result$x.hat)

## ------------------------------------------------------------------------
# Printing weights for first level of education
# before integerisation
result$x.hat[,,1]

# Printing weights for first level of education
# after integerisation
mipfp_int[,,1]

## ------------------------------------------------------------------------
int_expand_vector <- function(x){
  index <- 1:length(x)
  rep(index, round(x))
}

## ------------------------------------------------------------------------
int_weight1 # print weights 

# Expand the individual according to the weights
exp_indices <- int_expand_vector(int_weight1)
exp_indices

## ------------------------------------------------------------------------
# Generate spatial microdata for zone 1
ind_full[exp_indices,]

## ------------------------------------------------------------------------
int_expand_array <- function(x){
  # Transform the array into a dataframe
  count_data <- as.data.frame.table(x)
  # Store the indices of categories for the final population
  indices <- rep(1:nrow(count_data), count_data$Freq)
  # Create the final individuals
  ind_data <- count_data[indices,]
  ind_data
}

## ------------------------------------------------------------------------
# Expansion step
ind_mipfp <- int_expand_array(mipfp_int)

# Printing final results
head(ind_mipfp)

## ------------------------------------------------------------------------
# Method 1: using a for loop
ints_df <- NULL
set.seed(42)
for(i in 1:nrow(cons)){
  # Integerise and expand
  ints <- int_expand_vector(int_trs(weights[, i]))
  # Take the right individuals
  ints_df <- rbind(ints_df, data.frame(ind_full[ints,], zone = i))
}

# Method 2: using apply
set.seed(42)
ints_df2 <- NULL
# Take the right indices
ints2 <- unlist(apply(weights, 2, function(x)
  int_expand_vector(int_trs(x))))
# Generate the individuals
ints_df2 <- data.frame(ind_full[ints2,],
  zone = rep(1:nrow(cons), colSums(weights)))

## ------------------------------------------------------------------------
ints_df[ints_df$zone == 2, ]

## ---- echo=FALSE---------------------------------------------------------
# library(knitr)
# kable(ints_df[ints_df$zone == 2,], row.names = FALSE)

## ---- echo=FALSE, eval=FALSE---------------------------------------------
## save.image(file = "cache-smsim-in-R.RData")

## ---- echo=FALSE---------------------------------------------------------
# We need to establish which is faster (RL)

## ---- echo=FALSE---------------------------------------------------------
# TODO: (MD) compare with simpleworld
#       (MD) if mipfp is better, justify why we use ipfp with cakemap... Or compare also with cakemap

# TODO (RL): cross reference image of CO vs reweighting approaches

## ------------------------------------------------------------------------
# SimpleWorld constraints for zone 1
con_age[1,]
con_sex[1,]

# Save the constraints for zone 1
con_age_1 <- as.matrix( con_age[1,] )
con_sex_2 <- data.matrix( con_sex[1, c(2,1)] ) 

## ------------------------------------------------------------------------
# Save the target and description for Ipfp
target <- list (con_age_1, con_sex_2)
descript <- list (1, 2)

## ------------------------------------------------------------------------
# load full ind data
ind_full <- read.csv("data/SimpleWorld/ind-full.csv") 
# Add income to the categorised individual data
ind_income <- cbind(ind, ind_full[,c("income")])
weight_init <- table(ind_income[, c(2,3,4)])

## ------------------------------------------------------------------------
# Perform Ipfp on SimpleWorld example
weight_mipfp <- Ipfp(weight_init, descript, target,
  print = TRUE, tol = 1e-5)

## ---- echo=FALSE---------------------------------------------------------
# TODO: print spatial microdata output for zone II for clarity

## ------------------------------------------------------------------------
# Printing the resulting margins
weight_mipfp$check.margins

# Printing the resulting weight matrix for age and sex
apply(weight_mipfp$x.hat, c(1,2), sum)

## ------------------------------------------------------------------------
# Initialising the result matrix
Names <- list(1:3, colnames(con_sex)[c(2,1)], colnames(con_age))
Mipfp_Tab <- array(data = NA, dim = c(n_zone, 2 , 2), 
                   dimnames = Names)

# Loop over the zones and execute Ipfp
for (zone in 1:n_zone){
  # Adapt the constraint to the zone
  con_age_1 <- data.matrix(con_age[zone,] )
  con_sex_2 <- data.matrix(con_sex[zone, c(2,1)] ) 
  target <- list(con_age_1, con_sex_2)
  
  # Calculate the weights
  res <- Ipfp(weight_init, descript, target, tol = 1e-5)
  
  # Complete the array of calculated weights
  Mipfp_Tab[zone,,] <- apply(res$x.hat,c(1,2),sum)
}

## ------------------------------------------------------------------------
# Result for zone 1
Mipfp_Tab[1:2,,]

## ------------------------------------------------------------------------
# Repeat the initial matrix n_zone times
init_cells <- rep(weight_init, each = n_zone)

# Define the names
names <- c(list(c(1, 2, 3)), as.list(dimnames(weight_init)))

# Structure the data
mipfp_zones <- array(init_cells,
  dim = c(n_zone, n_age, n_sex, 5),
  dimnames = names)

## ------------------------------------------------------------------------
table(mipfp_zones[1,,,] == weight_init)

## ------------------------------------------------------------------------
con_age

## ------------------------------------------------------------------------
# Adapt target and descript 
target <- list(data.matrix(con_age),
  data.matrix(con_sex[,c(2,1)]))
descript <- list (c(1,2), c(1,3))

## ------------------------------------------------------------------------
res <- Ipfp(mipfp_zones, descript, target, tol = 1e-5)

## ------------------------------------------------------------------------
# Initialise the matrix 
weights_mipfp <- matrix(nrow = nrow(ind), ncol = nrow(cons))

# Cross-tabulated contingency table of the microdata, ind
Ind_Tab <- table(ind[,c(2,3)])

## ------------------------------------------------------------------------
# Loop over the zones to transform the result's structure
for (zone in 1:n_zone){
  
  # Transformation into individual weights
  for (i in 1:n_ind){
    # weight of the category
    weight_ind <- Mipfp_Tab[zone, ind[i, 2], ind[i, 3]]
    
    # number of ind in the category
    sample_ind <- Ind_Tab[ind[i, 2], ind[i, 3]]
    
    # distribute the weight to the ind of this category
    weights_mipfp[i,zone] <- weight_ind / sample_ind
  }
}

## ---- echo=FALSE---------------------------------------------------------
# Note: this function may not work on all data
# TODO (all): speculate if this can be more general (done - Jojo)
restructure <- function(Mipfp_Tab, weights, ind, zindex = 1){
  n_zone <- dim(Mipfp_Tab)[zindex] # number of zones
  for (zone in 1:n_zone){
    for (i in 1:nrow(ind)){
      # weight of the category
      weight_ind <- Mipfp_Tab[zone, ind[i, 2], ind[i, 3]]
    
      # number of ind in the category
      sample_ind <- Ind_Tab[ind[i, 2], ind[i, 3]]
    
      # distribute the weight to the ind of this category
      weights_mipfp[i,zone] <- weight_ind / sample_ind
    }
  }
  weights_mipfp
}

## ------------------------------------------------------------------------
# Difference between weights of ipfp and mipfp
abs(weights - weights_mipfp)

## ------------------------------------------------------------------------
# Save the matrix in a new variable
int_mipfp <- res$x.hat
# Integerise zone per zone
for (i in 1:n_zone){
  int_mipfp[i,,,] <- int_trs(int_mipfp[i,,,])
}

## ------------------------------------------------------------------------
# Expansion of mipfp integerised weight matrix
indiv_mipfp <- int_expand_array(int_mipfp)
Names <- c("Zone", "Age", "Sex", "Income", "Freq")
colnames(indiv_mipfp) <- Names

## ------------------------------------------------------------------------
ints_df[ints_df$zone == 2, ]
indiv_mipfp[indiv_mipfp$Zone==2,]

## ---- eval=FALSE---------------------------------------------------------
## ind_mipfp <- int_expand_array(int_trs(res$x.hat))

## ---- eval=FALSE---------------------------------------------------------
## # Chose correct constraint for mipfp
## con_age_1 <- data.matrix( con_age[1,] )
## con_sex_2 <- data.matrix( con_sex[1, c(2,1)] )
## target <- list (con_age_1, con_sex_2)
## descript <- list (1, 2)
## 
## # Equitable calculus - remove income
## weight_init_no_income <- table( ind[, c(2,3)])
## 
## # Measure time mipfp
## system.time(Ipfp( weight_init_no_income, descript, target,
##                   tol = 1e-5))

## ------------------------------------------------------------------------
# input for ipfp
ind_cat

# input for mipfp
Ind_Tab

## ---- echo=FALSE, eval=FALSE---------------------------------------------
## #### time tests for bigger databases
## 
## ind_cat2 <- ind_cat
## 
## for (i in 1:4999){
##   ind_cat2<-rbind(ind_cat2,ind_cat)
## }
## 
## Ind_Tab2 <- 5000 * Ind_Tab
## 
## cons2 <- cons * 1000000
## 
## # Measure time ipfp
## system.time(ipfp(cons2[1,], t(ind_cat2), x0 = rep(1,n_ind * 5000),  tol = 1e-5))
## 
## # Chose right constraint for mipfp
## target <- list (data.matrix(con_age[zone,] * 1000000), data.matrix(con_sex[zone,]  * 1000000)[c(2,1)])
## 
## # Equitable calculus - remove income
## weight_init_no_income <- table( ind[, c(2,3)])*5000
## 
## # Measure time mipfp
## system.time(Ipfp( weight_init_no_income, descript, target, tol = 1e-5))

