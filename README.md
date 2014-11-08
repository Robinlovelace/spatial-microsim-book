spatial-microsim-book gh-pages branch
=====================

This is the website of a book to be published by CRC Press's
[R Series](http://www.crcpress.com/browse/series/crctherser).

The current working draft can be viewed online on
[the book's homepage](http://robinlovelace.net/spatial-microsim-book/).
Anyone can contribute to this book
[here](https://github.com/Robinlovelace/spatial-microsim-book).

Merges to this branch should only be one way: `master -> gh-pages`:

```
# from the master branch:
cp -v *.Rmd /tmp/ # copy all .Rmd files to temp folder
git checkout gh-pages # switch to website branch
mv /tmp/*.Rmd . # move copied files
rm book.* # remove book files
```

To compile this website, simply clone it and run the final lines
of bbuild.R, followed by 
`jekyll-build`. All .Rmd files should be kept on the master branch.


