# Book building functions
Rmd_bind <- function(dir = ".",
  book_header = readLines(textConnection("---\ntitle: 'Title'\n---")),
  chap_ord = NULL){
  old <- setwd(dir)
  if(length(grep("book.Rmd$", list.files())) > 0){
    warning("book.Rmd already exists")
  }
  cfiles <- list.files(pattern = "*.Rmd", )
  cfiles <- cfiles[-grep("book", cfiles)]
  if(!is.null(chap_ord)) cfiles <- cfiles[chap_ord] # chapter order
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
  book_header = readLines(textConnection("---\ntitle: 'Title'\n---")),
  chap_ord = NULL){
  old <- setwd(dir)
  if(length(grep("book.Rmd", list.files())) > 0){
    warning("book.Rmd already exists")
  }
  cfiles <- list.files(pattern = "*.Rmd$", )
  cfiles <- cfiles[-grep("book", cfiles)]
  if(!is.null(chap_ord)) cfiles <- cfiles[chap_ord] # chapter order
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
