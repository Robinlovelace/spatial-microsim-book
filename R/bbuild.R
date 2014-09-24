# code to build the book
b <- readLines("book-cambridge.tex") # read in tex file

bgn <- grep("Introduction", b)[1]
b <- b[bgn:(length(b) - 2)]
b <- gsub("\\\\section\\{", "\\\\chapter\\{", x = b)
b <- gsub("\\\\subsection\\{", "\\\\section\\{", x = b)

# Take a subset of b (to test where fails occur)
# b <- b[1:400]

# Additional material to include
# a <- "\\usepackage{hyperref}"

k <- readLines("~/Desktop/Krantz_v1.11/Example/Run_This_Example.tex")
# kp <- 9 # where do package descriptions end?
# kf <- grep("mainmatter", k) # frontmatter up to and including here
kf <- readLines("frontmatter/pream.tex")
kb <- grep("bibliographystyle", k) # frontmatter up to and including here

# kp <- k[1:kp]
# kf <- k[(length(kp) + 1):kf] # frontmatter
kb <- k[kb:length(k)]

# kp <- c(kp, a)

k <- c(kf, b, kb)
writeLines(k, con = "spatial-microsim-book.tex")

# out-takes - code not used
# b[1] <- gsub("documentclass\\[\\]\\{article\\}", "documentclass\\[krantz1,ChapterTOCs\\]\\{krantz\\}", x = b[1]) # change 1st line
# gsub("\\\\section\\{", "\\\\chapter\\{", x = b[108]) # test gsub