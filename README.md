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

**Building the book**

To compile the book you will first need to download this repository. Do this by clicking the '[Download ZIP](https://github.com/Robinlovelace/spatial-microsim-book/archive/master.zip)' button to the right or by [cloning](http://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) this repository. To clone this repo from a Linux terminal, for example, type:

```
git clone https://github.com/Robinlovelace/spatial-microsim-book.git
```

Then navigate into the downloaded folder and open the `spatial-microsim-book.Rproj` RStudio project file. The [build.R](https://github.com/Robinlovelace/spatial-microsim-book/blob/master/build.R) file should contain everything you need to build the book, although you'll need to have installed a number of packages. These can be installed with the following command:

```
pkgs <- c("knitr", "rmarkdown", "png", "ggmap", "dplyr", "ipfp", "rgeos", "mipfp", "rgdal", "gridExtra", "tidyr", "mlogit")
install.packages(pkgs)
```

The GREGWT package can be installed as follows:

```
devtools::install_github("emunozh/GREGWT")
```

To install `ipfp` on Ubuntu (tested with version 14.04, the latest 'long-term support' version at the time of writing) a number of additional packages are required. These can be installed from the command line with:

```
sudo apt-get install liblapack-dev liblapack3 libopenblas-base libopenblas-dev
```

The book build also requires an up-to-date version of pandoc - install with:

```
sudo apt-get install pandoc
```

**Building the website**

The [gh-pages](https://github.com/Robinlovelace/spatial-microsim-book/tree/gh-pages) branch of this repo contains the book's [website](http://robinlovelace.net/spatial-microsim-book/).
Merges to the gh-pages website branch should only be one way: `master -> gh-pages`:

```
# from within the master branch:
cp -v *.Rmd /tmp/ # copy all .Rmd files to temp folder
git checkout gh-pages # switch to website branch
mv /tmp/*.Rmd . # move copied files
rm book.* # remove book files
```

The [build.R](https://github.com/Robinlovelace/spatial-microsim-book/blob/gh-pages/build.R) file in the `gh-page` branch contains further information on building the website.

For more information about GitHub, please see the free online book *[Pro Git](http://git-scm.com/book/en/v2)*.
