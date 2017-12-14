# TODO for the book project overall
# Individual chapters on eprints
# Implement regex to make bibliography happen in CRC press style
# Add urls to all the references and packages
# Propensity to cycle
# IPF in R/loglin/mipfp/GREGWT
# Reference UrbanSim
# Chapter summaries at outset?
# Mention of collaborative project early on

pkgs <- c("knitr", "rmarkdown", "png", "ggmap", "dplyr", "ipfp", "rgeos", "mipfp", "rgdal", "gridExtra", "maptools", "jpeg", "tmap", "tidyr", "mlogit", "simPop")
wpacks <- pkgs %in% installed.packages()
install.packages(pkgs[!wpacks])

# file.copy(from = "~/Documents/smr.bib", to = "bibliography.bib", overwrite = T)

# # View the order chapters will be knitted (see code/book-functions.R)
# # chap_ord <- c(7,16,10,5,12,2,8,4,13,14,15,11,1,3,6,9)
# cfiles <- list.files(pattern = "*.Rmd$")
# # cfiles <- cfiles[chap_ord] # chapter order
# cfiles
# 
# # Add book header
# book_header = readLines(textConnection('---
# title: "Spatial microsimulation with R"
# output:
# \ \ pdf_document:
# \ \ \ \ fig_caption: yes
# \ \ \ \ highlight: monochrome
# \ \ \ \ includes: null
# \ \ \ \ keep_tex: yes
# \ \ \ \ number_sections: yes
# \ \ \ \ toc: yes
# bibliography: bibliography.bib
# csl: elsevier-harvard.csl
# layout: default
# ---'))
# 
# source("code/book-functions.R")
# # file.remove("book.Rmd")
# # Rmd_bind(book_header = book_header) 
# Rmd_bind_mod(book_header = book_header)
# 
# # Packages needed to build the book
# # install.packages("knitr", "rmarkdown", "png", "ggmap", "dplyr", "ipfp") 
# library(knitr)
# library(rmarkdown)
# 
# # Build the book:
# render("book.Rmd", output_format = "pdf_document")


# Build the CRC-formated version - requires local files
# need to build the .tex manually for references to compile
# source("code/build-CRC-version.R")
# # Make latex-specific changes automated
# booktex <- readLines("spatial-microsim-book.tex")
# booktex[grep("\\{Glossary\\}", booktex)]
# booktex <- gsub(pattern = "chapter\\{Glossary\\}", "chapter*\\{Glossary\\}\n\\\\addcontentsline{toc}{chapter}{Glossary}
# ", booktex)
# writeLines(booktex, "spatial-microsim-book.tex")
# in case index does not build - run again!
# system("pdflatex --interaction=nonstopmode  spatial-microsim-book.tex")

# For website build see gh-pages version

# Files to move to gh-pages branch
# file.remove("book.Rmd")

# Remove latex-specific document links for website
# cfiles <- list.files("/tmp", pattern = "*.Rmd", full.names = T)
# for(i in cfiles){
#   text <- readLines(i)
#   sel <- grepl("\\(\\#", text)
#   text <- text[!sel]
#   writeLines(text, con = i)
# }

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

# backup
# system("cp -rv ~/Dropbox/spatial-microsim-book /media/robin/data/backups/")

# command-line tools for dif tracking
# latexdiff book-b4-comments.tex book.tex > dif.tex
# pdflatex dif.tex 

