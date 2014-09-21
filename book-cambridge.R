
## ----, echo=FALSE--------------------------------------------------------
# This is an early draft of a book on spatial microsimulation, for teaching in Cambridge


## ----, fig.cap="Schematic of the spatial microsimulation technique", fig.width=4, fig.height=4, echo=FALSE----
library(png)
library(grid)
img <- readPNG("figures/msim-schema-lowres.png")
grid.raster(img)


## ----, echo=FALSE--------------------------------------------------------
# Why spend time and effort on reproducibility? The first answer is that
# reproducibility actually saves time in the long-run, by ensuring more
# readable code and allowing your results to be easily re-run at a later data.
# The second reason is more profound. Reproducibility is a prerequisite
# of falsifiability and falsifiability is the backbone of science
# (Popper, 1959).
# The results on non-reproducible research cannot be verified, reducing scientific
# credibility. These observations inform the book’s practical nature.
# The aim is simple: to provide a foundation in spatial microsimulation.
# http://en.wikipedia.org/wiki/Experiential_learning
# Poper's link also here
# [2011](http://www.manning.com/kabacoff/)


## ----, echo=FALSE--------------------------------------------------------
# expressing oneself.^[This video introduces the idea of
# expressing oneself in [R](http://youtu.be/wki0BqlztCo)].


## ----, echo=FALSE--------------------------------------------------------
# Yet the software used has a lasting
# impact, including what can and cannot be done
# and opportunities for collaboration.  explains the choice of R.
# In my own research, for example, a conscious decision was made early on to use
# R. This had subsequent knock-on impacts on
# the features, analysis and even design of my simulations.
# There are hundreds computer programming languages and many of these
# are general purpose and 'Turing complete', meaning they could, with
# sufficient effort, perform spatial microsimulation (or any other
# numerical operation). So why choose R?
# ^[Speed
# of execution is an arguable exception, an issue that can be tackled
# by vectorisation (see [Appendix A](#apR)) and judicious use of add-on *R packages*.]


## ----, echo=FALSE--------------------------------------------------------
# One may argue that saving a few keystrokes while writing
# code is not a priority but it is certain
# that the time savings of being concise can be vast.


## ----, echo=FALSE--------------------------------------------------------
# For speed-critical applications,
# R provides access to lower level languages. It
# is possible to say a lot in R in few lines of code,
# but it is also possible for users to create their own
# commands, allowing users complete control. 
# The reasons for using R for spatial
# microsimulation can be summarised by modifying
# the arguments put forward by Norman Matloff (2001)
# for using R in general. R is:
# 
# -  "the de facto standard among
#     professional statisticians", meaning that the spatial microsimulation
#     code can easily be modified to perform a variety of statistical operations.
#  
# 
# -   "a general
#     programming language, so that you can automate your analyses and
#     create new functions." This is particularly useful if you need to run the same
#     code in many different ways for many locations. In R, the computer
#     can be asked to iterate over as many combinations of model runs as desired.
# 
# -   open source, meaning its easy to share your code and reproduce your
#     findings anywhere in the world, without the worry of infringing copyright
#     licences. In work funded by the public, this also has a large benefit
#     in terms of education and the democratisation of research.


## ----, echo=FALSE--------------------------------------------------------
# Consider the following expression in the language of mathematics:
# 
# 
# 
# It is easy for experienced R users to translate this into R:
# 
# 
# 
# Note that although the R language is not quite as concise or elegant as
# mathematics, it is certainly faster at conveying the meaning of numerical
# operations than plain English and, in many cases, other programming languages.
# 
# 
# 
# The unusually concise nature of R code is not an accident. It was
# planned to be this way from the outset by its early developers, Robert
# Gentleman and Ross Ihaka, who thought carefully about syntax from the
# outset: "the syntax of a language is important because it determines the
# way that users of the language express themselves" (Ihaka and Gentleman, 2014, p. 300).
# 
# If you are new to R but have some experience with data analysis and
# microsimulation, do not feel intimidated that R is a foreign language.
# As with a spoken language, often the best way to learn is to
# 'jump in the deep end' by living abroad, so learning R through the course
# of this book is certainly an option. However, a deep understanding of R
# will greatly assist understanding the practical elements of the book which
# begin in earnest in [Chapter 4](#DataPrep). Therefore an introductory
# tutorial is provided in [Appendix 1](#apR) which will allow this book
# to focus primarily on the methods of spatial microsimulation and not the
# language in which they are implemented.


## ------------------------------------------------------------------------
x <- c(1, 2, 5, 10) # create a vector
sqrt(x) # find the square root of x


## ----, echo=FALSE--------------------------------------------------------
# # What is spatial microsimulation?
# 
# Spatial microsimulation, as used in this book, is
# statistical technique for allocating individuals from a survey dataset
# to administrative zones based on shared variables between the areal and
# individual level data.
# 
# However, as with many new and infrequently used phrases, this
# understanding is not shared by everyone. The meaning of spatial
# microsimulation varies depending on context: to an
# economist spatial microsimulation is likely to imply
# modelling temporal processes such as how individual agents 
# respond to changes in prices or policies. To a transport
# planner, the term implies simulating the precise movements of vehicles on
# the transport network. To your next door neighbour it may mean you have
# started speaking gobbledygook! Hence the need to define our terminology.
# 
# Terminology
# -----------
# 
# Delving a little into the etymology and history of the term reveals the
# reasons behind this duplicity of meaning and highlights the importance
# of terminology. Only in very few contexts will one be understood when
# one says “I use *spatial microsimulation*” in everyday life. Usually it
# is important to add context. Below are a few hypothetical situations and
# suggestions of how one could respond to them.
# 
# -   When talking to a colleague, a transport modeller: “spatial
#     microsimulation, also known as population synthesis...”
# 
# -   Speaking to agent based modellers: “we use spatial microsimulation
#     to simulate the characteristics of geo-referenced agents...”
# 
# -   Communicating with undergraduates who are unlikely to have come
#     across the term or its analogies. “I do spatial microsimulation, a
#     way of generating individual-level data for small areas...”
# 
# -   Chatting casually in the pub or coffee shop: “I’m using a technique
#     called spatial microsimulation to model people...”.
# 
# The above examples illustrate that there is great potential for
# confusion and shows that care needs to be taken to tailor the words used
# depending on the target audience. All this links back to the importance
# of transparency and reproducibility of method discussed in .
# 
# Faced with uncomprehending stares when describing the method, some may
# be tempted to ‘blind them with science’, relying on
# sophisticated-sounding jargon, for example by saying: “we use simulated
# annealing in our integerised spatial microsimulation model”. Such
# wording obscures meaning (how many people in the room will understand
# ‘integerised’, let alone ‘simulated annealing’) and makes the process
# sound inaccessible. Although much jargon is used in the spatial
# microsimulation literature in this book, care must be taken to ensure
# that people understand what you are saying.
# 
# This raises the question, why use the term spatial microsimulation at
# all, if it is understood by so few people? The answer to this is that
# spatial microsimulation, defined clearly at the outset and used
# correctly, can usefully describe a technique that would otherwise need
# many more words on each use. Try replacing ‘spatial microsimulation’
# with ‘a statistical technique to allocate individuals from a survey
# dataset to administrative zones based on shared variables between the
# areal and individual level data’ each time it appears in this book and
# the advantages of a simple term should become clear. ‘Population
# synthesis’ is perhaps a more accurate term but, transport modelling
# aside, the literature already uses ‘spatial microsimulation’. Rather
# than create more complexity with *another* piece of jargon, it is best
# to continue with the term favoured by the the majority of practitioners.
# 
# Why has this situation, in which practitioners of a statistical method
# must tread carefully to avoid confusing their audience, come about?
# First it’s worth stating that the problem is by no means unique to this
# field: imagine the difficulties that Bayesian statisticians must
# encounter when speaking of prior and posterior probability distributions
# to an uninitiated audience. Let alone describing Gibb’s sampling. To
# more precisely answer the question, and gain an insight into the origins
# of the definition provided at the outset of this chapter, we consider
# the beginnings and evolution of the term in written work.
# 
# The etymology of spatial microsimulation
# ----------------------------------------
# 
# Spatial microsimulation as an approach to modelling {#sbroader}
# ---------------------------------------------------
# 
# What spatial microsimulation is not
# -----------------------------------
# 
# **Spatial microsimulation is not strictly spatial**
# 
# The most surprising feature of spatial microsimulation, as used in the
# literature, is that *the method is not trictly *spatial*. The only
# reason why the methodology has developed this name (as opposed to 'small
# area population synthesis', for example) is that practitioners tend
# to use administrative zones, which represent geographical areas, as the
# grouping variable. However, any mutually exclusive grouping variable,
# such as age band or number of bedrooms in your house, could
# be used. Likewise, geographical location can be used as a *constraint variable*.
# In most spatial microsimulation models, *the spatial variable is a mutually
# exclusive grouping, interchangeable with any such group*. "Spatial" is thus
# 1st on the list of things that spatial microsimulation is not.
# 
# To be more precise, spatial microsimulation is not *inherently spatial*.
# Spatial attributes such as the geographic coordinates of home and work
# locations can easily be added to the spatial microdata after they have been
# generated, and the use of geographical variables as the grouping variable is
# critical here. 
# 
# **Spatial microsimulation is not agent-based modelling (ABM).**


## ----fsimple1, fig.cap="The SimpleWorld sphere", echo=FALSE, message=FALSE----
# Code to create SimpleWorld
# Builds on this vignette: http://cran.r-project.org/web/packages/sp/vignettes/over.pdf
library(sp)
library(ggplot2)
xpol <- c(-180, -60, -60, -180, -180)
ypol <- c(-70, -70, 70, 70, -70)
pol = SpatialPolygons(list(
  Polygons(list(Polygon(cbind(xpol, ypol))), ID="x1"),
  Polygons(list(Polygon(cbind(xpol + 120, ypol))), ID="x2"),
  Polygons(list(Polygon(cbind(xpol + 240, ypol))), ID="x3")
  ))
# plot(pol)
proj4string(pol) <- CRS("+init=epsg:4326")
pol1 <- fortify(pol)

theme_space_map <- theme_bw() +
  theme(
#     rect = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid.major = element_line(size = 3)
  )

ggplot(pol1) + geom_path(aes(long, lat, group, fill = group)) +
    coord_map("ortho", orientation=c(41, -74, 52)) + 
  theme_space_map


## ----fig = "Mercator maps of the zones in SimpleWorld", echo=FALSE, message=FALSE----
con_age <- read.csv("data/SimpleWorld/age.csv")
con_sex <- read.csv("data/SimpleWorld/sex.csv")
cons <- cbind(con_age, con_sex)

# library(knitr)
# kable(con_age, row.names = T)
# kable(con_sex, row.names = T)

pol <- SpatialPolygonsDataFrame(pol, cons, match.ID = F)

# pol@data
pol$p_young <- pol$a0.49 / (pol$a.50. + pol$a0.49) * 100
pol$p_male <- pol$m / (pol$f + pol$m) * 100

pol$id <- c("x1", "x2", "x3")
library(plyr)
pol1 <- join(pol1, pol@data)
pol1$Name <- paste("Zone", 1:3, sep = " ")
pol1$xpos <- seq(-120, 120, length.out = 3)
pol1$ypos <- 0

# ggplot(pol1) + 
#   geom_polygon(aes(long, lat, group, fill = p_young)) +
#   geom_path(aes(long, lat, group, fill = p_young)) +
#   geom_text(aes(xpos, ypos, label = Name)) +
#   theme_bw() +
#   scale_fill_continuous(low = "black", high = "white", limits = c(0, 100),
#     name = "% Young") +
#   coord_map() 
# 
# ggplot(pol1) + 
#   geom_polygon(aes(long, lat, group, fill = p_male)) +
#   geom_path(aes(long, lat, group, fill = p_male)) +
#   geom_text(aes(xpos, ypos, label = Name)) +
#   theme_bw() +
#   scale_fill_continuous(low = "black", high = "white", limits = c(0, 100),
#     name = "% Male") +
#   coord_map() 


## ----, echo=FALSE--------------------------------------------------------
# ind <- read.csv("data/SimpleWorld/ind.csv")
# ind$income <- round(rnorm(n = nrow(ind), mean = 1000, sd = 100))
# ind$income <- ind$income + 30 * ind$age
# ind$income[ ind$age == "f"] <- ind$income + 1000
# write.csv(ind, "data/SimpleWorld/ind-full.csv", row.names = F)
ind <- read.csv("data/SimpleWorld/ind-full.csv")
# kable(ind)


## ----, echo=FALSE, eval=FALSE--------------------------------------------
## cat_age <- model.matrix(~ ind$age - 1)
## cat_sex <- model.matrix(~ ind$sex - 1)[, c(2, 1)]
## ind_cat <- cbind(cat_age, cat_sex) # combine flat representations of the data
## ind$age <- cut(ind$age, breaks = c(0, 49, 120), labels = c("a0_49", "a50+"))
## weights <- matrix(data = NA, nrow = nrow(ind), ncol = nrow(cons))
## cons <- apply(cons, 2, as.numeric)
## library(ipfp) # load the ipfp library after: install.packages("ipfp")
## apply(cons, MARGIN = 1, FUN =  function(x) ipfp(x, t(ind_cat), x0 = rep(1,nrow(ind))))


## ----, echo=FALSE--------------------------------------------------------
# Add section link here!


## ----, echo=FALSE--------------------------------------------------------
# Applications of spatial microsimulation - to be completed!

## Updating cross-tabulated census data

## Economic forecasting

## Small area estimation

## Transport modelling

## Dynamic spatial microsimulation

## An input into agent based models


## ----, echo=FALSE--------------------------------------------------------
# With the foundations built in the previous chapters now (hopefully) firmly in-place,
# we progress in this chapter to actually *run* a spatial microsimulation model
# This is designed to form the foundation of a spatial microsimulation course.


## ----, echo=FALSE--------------------------------------------------------
# This next chapter is where people get their hands dirty for the first time -
# could be the beginning of part 2 if the book's divided into parts. 


## ----, echo=FALSE--------------------------------------------------------
# It sounds trivial, but the *precise* origin of the input data
# should be described. Comments in code that loads the data (and resulting publications),
# allows you or others to recall the raw information. # going on a little -> rm
# Show directory structure plot from Gillespie here


## ------------------------------------------------------------------------
# Load the individual-level data
ind <- read.csv("data/SimpleWorld/ind.csv") 
class(ind) # verify the data type of the object
ind # print the individual-level data


## ----, echo=FALSE--------------------------------------------------------
### Loading and checking aggregate-level data


## ------------------------------------------------------------------------
con_age <- read.csv("data/SimpleWorld/age.csv")
con_sex <- read.csv("data/SimpleWorld/sex.csv")


## ------------------------------------------------------------------------
con_age


## ----, echo=FALSE--------------------------------------------------------
# Make the constraint data contain an 'id' column, possibly scrambled 


## ------------------------------------------------------------------------
sum(con_age)
sum(con_sex) 

rowSums(con_age)
rowSums(con_sex)
rowSums(con_age) == rowSums(con_sex)


## ------------------------------------------------------------------------
# Test binning the age variable
cut(ind$age, breaks = c(0, 49, 120))


## ------------------------------------------------------------------------
# Convert age into a categorical variable with user-chosen labels
(ind$age <- cut(ind$age, breaks = c(0, 49, 120), labels = c("a0_49", "a50+")))


## ------------------------------------------------------------------------
names(cons)


## ------------------------------------------------------------------------
levels(ind$age)
names(con_age)


## ------------------------------------------------------------------------
names(con_age) <- levels(ind$age) # rename aggregate variables


## ------------------------------------------------------------------------
cons <- cbind(con_age, con_sex)
cons[1:2, ] # display the constraints for the first two zones


## ------------------------------------------------------------------------
dim(ind)
dim(cons)


## ------------------------------------------------------------------------
cat_age <- model.matrix(~ ind$age - 1)
cat_sex <- model.matrix(~ ind$sex - 1)[, c(2, 1)]
(ind_cat <- cbind(cat_age, cat_sex)) # combine flat representations of the data


## ------------------------------------------------------------------------
colSums(ind_cat) # view the aggregated version of ind
ind_agg <- colSums(ind_cat) # save the result


## ------------------------------------------------------------------------
rbind(cons[1,], ind_agg) # test compatibility between ind_agg and cons objects


## ----, echo=FALSE--------------------------------------------------------
# How representative each individual is of each zone is determined by their
# *weight* for that zone. If we have `nrow(cons)` zones and `nrow(ind)`
# individuals (3 and 5, respectively, in SimpleWorld) we will create
# 15 weights. Real world datasets (e.g. that presented in chapter xxx)
# could contain 10,000 individuals
# to be allocated to 500 zones, resulting in an unwieldy 5 million element
# weight matrix but we'll stick with the SimpleWorld dataset here for simplicity.


## ------------------------------------------------------------------------
weights <- matrix(data = NA, nrow = nrow(ind), ncol = nrow(cons))
dim(weights) # the dimension of the weight matrix: 5 rows by 3 columns


## ----, echo=FALSE--------------------------------------------------------
# Possibly more on IPF here. For now, press on


## ------------------------------------------------------------------------
library(ipfp) # load the ipfp library after: install.packages("ipfp")
cons <- apply(cons, 2, as.numeric) # convert matrix to numeric data type
ipfp(cons[1,], t(ind_cat), x0 = rep(1, nrow(ind))) # run IPF


## ----, eval=FALSE--------------------------------------------------------
## ipfp(cons[1,], t(ind_cat), rep(1, nrow(ind)), maxit = 20, verbose = T)


## ------------------------------------------------------------------------
ind_catt <- t(ind_cat) # save transposed version of ind_cat


## ------------------------------------------------------------------------
x0 <- rep(1, nrow(ind)) # save the initial vector


## ------------------------------------------------------------------------
for(i in 1:ncol(weights)){
  weights[,i] <- ipfp(cons[i,], ind_catt, x0, maxit = 20)
}


## ------------------------------------------------------------------------
weights <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, maxit = 20))


## ----, echo=FALSE, eval=FALSE--------------------------------------------
## # Also discuss what happens when you get a huge dataset, from Stephen's dataset


## ------------------------------------------------------------------------
int_pp <- function(x){
  sample(length(x), size = round(sum(x)), prob = x, replace = T)
}


## ------------------------------------------------------------------------
set.seed(0)
int_pp(x = c(0.333, 0.667, 3))
int_pp(x = c(1.333, 1.333, 1.333))


## ------------------------------------------------------------------------
int_trs <- function(x){
  truncated <- which(x >= 1)
  replicated <- rep(truncated, floor(x[truncated]))
  r <- x - floor(x)
  def <- round(sum(x)) - length(replicated) # the deficit population
  if(def == 0){
    out <- replicated
  } else {
    out <- c(replicated, sample(length(x), size = def, prob = r, replace = F))
  }
  out
}


## ------------------------------------------------------------------------
int_trs(c(0.333, 0.667, 3))
int_trs(c(1.333, 1.333, 1.333))


## ------------------------------------------------------------------------
# Method 1: using a for loop
ints_df <- NULL
for(i in 1:nrow(cons)){
  ints <- int_trs(weights[, i])
  ints_df <- rbind(ints_df, data.frame(id = ints, zone = i))
}

# Method 2: using apply
ints <- unlist(apply(weights, 2, int_trs)) # generate integerised result
ints_df <- data.frame(id = ints, zone = rep(1:nrow(cons), colSums(weights)))


## ----, message=FALSE-----------------------------------------------------
ind_full <- read.csv("data/SimpleWorld/ind-full.csv")
library(dplyr) # install.packages(dplyr) if not installed
ints_df <- inner_join(ints_df, ind_full)


## ------------------------------------------------------------------------
ints_df[ints_df$zone == 2, ]


## ------------------------------------------------------------------------
library(knitr)
kable(ints_df[ints_df$zone == 2,], row.names = FALSE)


## ----, echo=FALSE--------------------------------------------------------
# A little long-winded - cut down?


## ----, echo=FALSE--------------------------------------------------------
# TODO: add more here...


## ------------------------------------------------------------------------
ind <- read.csv("data/CakeMap/ind.csv")
cons <- read.csv("data/CakeMap/cons.csv")


## ----, echo=FALSE--------------------------------------------------------
source("R/CakeMap.R")


## ----, eval=FALSE--------------------------------------------------------
## weights <- apply(cons, 1, function(x) ipfp(x, ind_catt, x0, maxit = 20))


## ------------------------------------------------------------------------
cor(as.numeric(cons), as.numeric(ind_agg))


## ------------------------------------------------------------------------
cor(as.numeric(cons), as.numeric(ind_agg))


## ------------------------------------------------------------------------
tae <- function(observed, simulated){
  obs_vec <- as.numeric(observed)
  sim_vec <- as.numeric(simulated)
  sum(abs(obs_vec - sim_vec))
}


## ----, eval=FALSE--------------------------------------------------------
## wardsF <- inner_join(wardsF, wards@data, by = "id")


## ----, fig.cap="CakeMap results: estimated average cake consumption in Leeds", fig.width=5, fig.height=4, echo=FALSE----
img <- readPNG("figures/CakeMap-lores.png")
grid.raster(img)


## ----, eval=FALSE--------------------------------------------------------
## wards@data <- join(wards@data, imd)
## summary(imd$NAME %in% wards$NAME)
## ##       Mode   FALSE    TRUE    NA's
## ##    logical      55      71       0


## ----, engine='python', eval=FALSE---------------------------------------
## a = [1,2,3]
## b = [9,8,6]
## print(a + b)


## ------------------------------------------------------------------------
a <- c(1, 2, 3)
b <- c(9, 8, 6)
a + b


## ------------------------------------------------------------------------
# Create a character and a vector object
char_obj <- c("red", "blue", "red", "green")
num_obj <- c(1, 4, 2, 532.1)

# Summary of each object
summary(char_obj)
summary(num_obj)

# Summary of a factor object
fac_obj <- factor(char_obj)
summary(fac_obj)


## ------------------------------------------------------------------------
ind <- read.csv("data/SimpleWorld/ind.csv") 


## ------------------------------------------------------------------------
ind[3,]


## ------------------------------------------------------------------------
ind$age # data.frame column name notation I
# ind[, 2] # matrix notation
# ind["age"] # column name notation II
# ind[[2]] # list notation
# ind[2] # numeric data frame notation


## ------------------------------------------------------------------------
ind[4, 3] # The attribute of the 4th individual in column 3


## ------------------------------------------------------------------------
ind[ind$sex == "f", ]
ind[ind$sex == "f" & ind$age > 50, ]


## ------------------------------------------------------------------------
# There are alternatives to R and in the next section we will consider a few of these.


