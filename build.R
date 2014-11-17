# TODO for the book project overall
# Individual chapters on eprints
# implement regex to make bibliography happen in CRC press style

book_header = readLines(textConnection('---
title: "Spatial microsimulation with R"
output:
\ \ pdf_document:
\ \ \ \ fig_caption: yes
\ \ \ \ includes: null
\ \ \ \ keep_tex: yes
\ \ \ \ number_sections: yes
\ \ \ \ toc: yes
bibliography: ~/Documents/smr.bib 
layout: default
---'))

source("R/functions.R")
# file.remove("book.Rmd")
Rmd_bind_mod(book_header = book_header)

library(knitr)
library(rmarkdown)

render("book.Rmd", output_format = "pdf_document")

source("R/bbuild.R")
system("pdflatex --interaction=nonstopmode  spatial-microsim-book.tex")
system("pdflatex --interaction=nonstopmode  spatial-microsim-book.tex")

# tidy up the mess
tt <- list.files(pattern = "*.aux|*.toc|*.log|*.lot|*.gz|*.idx|*.ilg|*.ind|*.ggmap", )

for(i in tt){
  system(paste('rm', i))
}

# For website build see gh-pages version

# # # regex with R - convert book ready for regexxing
# d <- readLines("introduction.Rmd")
# sel <- grep("@", d)
# s <- d[sel]
# gsub(".+?(?=a)", replacement = "", s, perl = T) # test of greedy matching
# 
# # select quotes
# 
# s <- grep(" @", d)
# s <- grep("\\ @|\\[@", d)
# d[s]

