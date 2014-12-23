# TODO for the book project overall
# Individual chapters on eprints
# Create another worked example, of variability in inequality -> paper
# Implement regex to make bibliography happen in CRC press style
# Add urls to all the references and packages
# Propensity to cycle
# IPF in R/loglin/mipfp/GREGWT

# View the order chapters will be knitted (see R/book-functions.R)
chap_ord <- c(6, 13, 8, 4, 10, 3, 11, 12, 9, 1, 2, 5, 7)
cfiles <- list.files(pattern = "*.Rmd$", )
cfiles <- cfiles[chap_ord] # chapter order
cfiles

# Add book header
book_header = readLines(textConnection('---
title: "Spatial microsimulation with R"
output:
\ \ pdf_document:
\ \ \ \ fig_caption: yes
\ \ \ \ highlight: monochrome
\ \ \ \ includes: null
\ \ \ \ keep_tex: yes
\ \ \ \ number_sections: yes
\ \ \ \ toc: yes
layout: default
---'))

source("R/book-functions.R")
# file.remove("book.Rmd")
# Rmd_bind(book_header = book_header) 
Rmd_bind_mod(book_header = book_header, chap_ord = chap_ord)

# Packages needed to build the book
# install.packages("knitr", "rmarkdown", "png", "ggmap", "dplyr", "ipfp") 
library(knitr)
library(rmarkdown)

# Build the book:
render("book.Rmd", output_format = "pdf_document")

# # Build the CRC-formatted version of the book
# source("R/bbuild.R")
# system("pdflatex --interaction=nonstopmode  spatial-microsim-book.tex")
# system("pdflatex --interaction=nonstopmode  spatial-microsim-book.tex")
# 
# # tidy up the mess
# tt <- list.files(pattern = "*.aux|*.toc|*.log|*.lot|*.gz|*.idx|*.ilg|*.ind|*.ggmap", )
# 
# for(i in tt){
#   system(paste('rm', i))
# }
# 
# # For website build see gh-pages version
# 
# # Files to move to gh-pages branch
# file.remove("book.Rmd")
# 
# # Remove latex-specific document links for website
# cfiles <- list.files("/tmp", pattern = "*.Rmd", full.names = T)
# for(i in cfiles){
#   text <- readLines(i)
#   sel <- grepl("\\(\\#", text)
#   text <- text[!sel]
#   writeLines(text, con = i)
# }
# 
# # # # regex with R - convert book ready for regexxing
# # d <- readLines("introduction.Rmd")
# # sel <- grep("@", d)
# # s <- d[sel]
# # gsub(".+?(?=a)", replacement = "", s, perl = T) # test of greedy matching
# # 
# # # select quotes
# # 
# # s <- grep(" @", d)
# # s <- grep("\\ @|\\[@", d)
# # d[s]

