spatial-microsim-book
=====================

This is a variant on the CakeMap.R code which does not integerise the weights in order to select whole units but keeps the fractional weights and creates a long form data table with these weights attached to the individual cases.

As I have not (yet) worked out how to do a weighted 'aggregate' in R the script then outputs the table as a .csv file & I use the included STATA script to calculate the number of people in each cake category in each zone. This in turn outputs this result as a .csv file to be read back into R for mapping etc (to do!)

Comments welcome: dataknut@icloud.com

