# Functions useful for spatial microsimulation
# What others would be useful?
# Could any of these be improved?
# Let me know if so - rob00x@gmail.com

# 'Proportional probabilities' (PP) method of integerisation
# (see http://www.sciencedirect.com/science/article/pii/S0198971513000240):
int_pp <- function(x){
  sample(length(x), size = round(sum(x)), prob = x, replace = T)
}

# 'Truncate, replicate, sample' (TRS) method of integerisation
# (see http://www.sciencedirect.com/science/article/pii/S0198971513000240):
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

# Total absolute error
tae <- function(observed, simulated){
  obs_vec <- as.numeric(observed)
  sim_vec <- as.numeric(simulated)
  sum(abs(obs_vec - sim_vec))
}

