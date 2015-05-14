# file.edit("_includes/programming-nav.html") # edits chapter order
# file.edit("frontmatter/index.html") # edit frontmatter

# For website build
system("cp -v /tmp/*.Rmd .") # move copied files
system("rm book.*") # remove book files")
system("rm -v *.html")

# Remove all ](# references
rmds <- list.files(pattern = ".Rmd")
for(i in rmds){
  f <- readLines(i)
  sel <- grep(pattern = "\\]\\(#", x = f)
  print(f[sel])
  f <- f[-sel]
  writeLines(text = f, con = i)
}

system("cp -v frontmatter/index.html .")
# then type 'jekyll build' or 'jekyll serve' in bash


# warning: run only after jekyll!
# file.remove("temp.html")
# system("mv -v _site/*.html .") # copy site dir to local
# system("rm -v *.Rmd") # remove .Rmd files - or just don't add them


# then push directly to the internet