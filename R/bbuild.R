# code to build the book
b <- readLines("book.tex") # read in tex file

bgn <- grep("Introduction", b)[1]
b <- b[bgn:(length(b) - 2)]
b <- gsub("\\\\section\\{", "\\\\chapter\\{", x = b)
b <- gsub("subsection\\{", "section\\{", x = b)

# Take a subset of b (to test where fails occur)
# b <- b[1:400]

# Additional material to include
# a <- "\\usepackage{hyperref}"

# kp <- 9 # where do package descriptions end?
# kf <- grep("mainmatter", k) # frontmatter up to and including here
kf <- readLines("frontmatter/pream.tex")

# kp <- k[1:kp]
# kf <- k[(length(kp) + 1):kf] # frontmatter

# kp <- c(kp, a)

k <- c(kf, b, c("\\printindex", "\\end{document}"))


biblilines <- grep("section\\*\\{Bibliography\\}|\\{section\\}\\{Bibliography\\}", x = k)
kbl <- k[biblilines]
kbl <- gsub(pattern = "section", replacement = "chapter", x = kbl)

# glosline <-  grep("chapter\\{Glossary\\}", x = k)
# k[(glosline - 1):(glosline + 2)]
# k[glosline + 1] <- "\\addcontentsline{toc}{chapter}{Glossary}"

k[biblilines] <- kbl

# add part 1
p1 <- "\\part{Introducing spatial microsimulation with R}"
p2 <- "\\part{Generating spatial microdata}"
p3 <- "\\part{Modelling spatial microdata}"

ps <- grep(pattern = "\\chapter\\{Intro|\\chapter\\{Data|\\chapter\\{The T", x = k)

k <- c(
  k[1:(ps[1] -1)],
  p1, k[ps[1]:(ps[2] -1)],
  p2, k[ps[2]:(ps[3] -1)],
  p3, k[ps[3]:length(k)]
  )


writeLines(k, con = "spatial-microsim-book.tex")

# out-takes - code not used
# b[1] <- gsub("documentclass\\[\\]\\{article\\}", "documentclass\\[krantz1,ChapterTOCs\\]\\{krantz\\}", x = b[1]) # change 1st line
# gsub("\\\\section\\{", "\\\\chapter\\{", x = b[108]) # test gsub