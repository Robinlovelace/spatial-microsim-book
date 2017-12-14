# Build the CRC-formatted version of the book
source("code/bbuild.R")
system("pdflatex --interaction=nonstopmode  spatial-microsim-book.tex")
system("pdflatex --interaction=nonstopmode  spatial-microsim-book.tex")

# tidy up the mess
tt <- list.files(pattern = "*.aux|*.toc|*.log|*.lot|*.gz|*.idx|*.ilg|*.ind|*.ggmap", )

for(i in tt){
  system(paste('rm', i))
}
