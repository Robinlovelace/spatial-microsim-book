Spatial microsimulation with R book project
=====================

This is the directory of code, sample data and content of a book on
'spatial microsimulation' to be published by CRC Press in the
[R Series](http://www.crcpress.com/browse/series/crctherser).

The current working draft can be viewed online on
[the book's homepage](http://robinlovelace.net/spatial-microsim-book/).
Anyone can contribute to this book [here](https://github.com/Robinlovelace/spatial-microsim-book).

Any questions about the book? Want to review an early version?
Please contact me on rob00x-at-gmail.com.

**Building the website**

Merges to the gh-pages website branch should only be one way: `master -> gh-pages`:

```
# from within the master branch:
cp -v *.Rmd /tmp/ # copy all .Rmd files to temp folder
git checkout gh-pages # switch to website branch
mv /tmp/*.Rmd . # move copied files
rm book.* # remove book files
```

For more information about GitHub, please see the below introduction:

http://philmikejones.wordpress.com/2014/09/18/using-git-and-github/
