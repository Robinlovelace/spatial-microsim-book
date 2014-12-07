book_header = readLines(textConnection('---
title: "Spatial microsimulation with R"
output:
\ \ pdf_document:
\ \ \ \ fig_caption: yes
\ \ \ \ includes: null
\ \ \ \ keep_tex: yes
\ \ \ \ number_sections: yes
\ \ \ \ toc: yes
layout: default
---'))

source("R/functions.R")
Rmd_bind_mod(book_header = book_header)

library(knitr)
library(rmarkdown)

render("book.Rmd", output_format = "pdf_document")
tt <- list.files(pattern = "*.aux|*.toc|*.log|*.lot|*.gz|*.idx|*.ilg|*.ind|*.ggmap", )

source("R/bbuild.R")
system("pdflatex --interaction=nonstopmode  spatial-microsim-book.tex")

for(i in tt){
  system(paste('rm', i))
}

# For website build
system("cp -v /tmp/*.Rmd .") # move copied files
system("rm book.*") # remove book files")
system("rm -v *.html")

system("cp -v frontmatter/index.html .")
# then type 'jekyll build' or 'jekyll serve' in bash

file.remove("temp.html")
system("mv -v _site/*.html .") # copy site dir to local
system("rm *.Rmd")


# then push directly to the internet