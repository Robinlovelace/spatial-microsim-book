# Functions useful for spatial microsimulation
# What others would be useful?
# Could any of these be improved?
# Let me know if so - rob00x@gmail.com

# 'Proportional probabilities' (PP) method of integerisation
# (see http://www.sciencedirect.com/science/article/pii/S0198971513000240):
int_pp <- function(x){
  xv <- as.vector(x)
  xint <- rep(0, length(x))
  xs <- sample(length(x), size = round(sum(x)), prob = x, replace = T)
  xsumm <- summary(as.factor(xs))
  topup <- as.numeric(names(xsumm))
  xint[topup] <- xsumm
  dim(xint) <- dim(x)
  xint
}

# 'Truncate, replicate, sample' (TRS) method of integerisation
# (see http://www.sciencedirect.com/science/article/pii/S0198971513000240):
int_trs <- function(x){
  xv <- as.vector(x)
  xint <- floor(xv)
  r <- xv - xint
  def <- round(sum(r)) # the deficit population
  # the weights be 'topped up' (+ 1 applied)
  topup <- sample(length(x), size = def, prob = r)
  xint[topup] <- xint[topup] + 1
  dim(xint) <- dim(x)
  dimnames(xint) <- dimnames(x)
  xint
}

int_expand_vector <- function(x){
  index <- 1:length(x)
  rep(index, round(x))
}

int_expand_array <- function(x){
  # Transform the array into a dataframe
  count_data <- as.data.frame.table(x)
  # Store the indices of categories for the final population
  indices <- rep(1:nrow(count_data), count_data$Freq)
  # Create the final individuals
  ind_data <- count_data[indices,]
  ind_data
}



# Total absolute error
tae <- function(observed, simulated){
  obs_vec <- as.numeric(observed)
  sim_vec <- as.numeric(simulated)
  sum(abs(obs_vec - sim_vec))
}

# Number of times each unique matrix row appears
umat_count <- function(x) {
  xp <- apply(x, 1, paste0, collapse = "") # "pasted" version of constraints
  freq <- table(xp) # frequency of occurence of each individual
  xu <- unique(x) # save only unique individuals
  rns <- as.integer(row.names(xu)) # save the row names of unique values of ind
  xpu <- xp[rns]
  o <- order(xpu, decreasing = TRUE) # the order of the output (to rectify table)
  cbind(xu, data.frame(ind_num = freq[o], rns = rns)) # output
}

# Generates list of outputs - requires dplyr
umat_count_dplyr <- function(x){
  x$p <- apply(x, 1, paste0, collapse = "")
  up <- data.frame(p = unique(x$p)) # unique values in order they appeared
  y <- dplyr::count(x, p) # fast freq table
  umat <- inner_join(up, y) # quite fast
  umat <- join(umat, x, match = "first")
  list(u = umat, p = x$p) # return unique individuals and attributes
}
