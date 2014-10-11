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

Rmd_bind_mod <- function(dir = ".",
  book_header = readLines(textConnection("---\ntitle: 'Title'\n---"))){
  old <- setwd(dir)
  if(length(grep("book.Rmd", list.files())) > 0){
    warning("book.Rmd already exists")
  }
  cfiles <- list.files(pattern = "*.Rmd$", )
  cfiles <- cfiles[c(6, 11, 8, 4, 10, 3, 9, 1, 2, 5, 7)]
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

Rmd_bind_mod(book_header = book_header)
