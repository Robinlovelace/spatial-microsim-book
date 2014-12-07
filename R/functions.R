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

umat_count_dplyr <- function(x){
  x$p <- apply(x, 1, paste0, collapse = "")
  up <- data.frame(p = unique(x$p)) # unique values in order they appeared
  y <- dplyr::count(x, p) # fast freq table
  umat <- inner_join(up, y) # quite fast
  umat <- join(umat, x, match = "first")
  list(u = umat, p = x$p) # return unique individuals and attributes
}

# Generates list of outputs
umat_count_dplyr <- function(x){
  x$p <- apply(x, 1, paste0, collapse = "")
  up <- data.frame(p = unique(x$p)) # unique values in order they appeared
  y <- dplyr::count(x, p) # fast freq table
  umat <- inner_join(up, y) # quite fast
  umat <- join(umat, x, match = "first")
  list(u = umat, p = x$p) # return unique individuals and attributes
}

# Book building functions
Rmd_bind <- function(dir = ".",
  book_header = readLines(textConnection("---\ntitle: 'Title'\n---"))){
  old <- setwd(dir)
  if(length(grep("book.Rmd$", list.files())) > 0){
    warning("book.Rmd already exists")
  }
  cfiles <- list.files(pattern = "*.Rmd", )
  write(book_header, file = "book.Rmd", )
  ttext <- NULL
  for(i in 1:length(cfiles)){
    text <- readLines(cfiles[i])
    hspan <- grep("---", text)
    text <- text[-c(hspan[1]:hspan[2])]
    write(text, sep = "\n", file = "book.Rmd", append = T)
  }
  #     render("book.Rmd", output_format = "pdf_document")
  setwd(old)
}

chap_ord <- c(6, 13, 8, 4, 10, 3, 11, 12, 9, 1, 2, 5, 7)

Rmd_bind_mod <- function(dir = ".",
  book_header = readLines(textConnection("---\ntitle: 'Title'\n---"))){
  old <- setwd(dir)
  if(length(grep("book.Rmd", list.files())) > 0){
    warning("book.Rmd already exists")
  }
  cfiles <- list.files(pattern = "*.Rmd$", )
  cfiles <- cfiles[-grep("book", cfiles)]
 cfiles <- cfiles[chap_ord] # chapter order
  write(book_header, file = "book.Rmd", )
  ttext <- NULL
  for(i in 1:length(cfiles)){
    text <- readLines(cfiles[i])
    hspan <- grep("---", text)
    text <- text[-c(hspan[1]:hspan[2])]
    refs <- grepl("# References", text) # Remove references section from each chapter
    text <- text[!refs]
    write(text, sep = "\n", file = "book.Rmd", append = T)
  }
  #     render("book.Rmd", output_format = "pdf_document")
  setwd(old)
}
