* script to read in results of R spatial microsim using ipf and run weighted stats
* in theory this should also be done in R when I work out how!

* change this to your path!
local where "/Users/ben/Documents/Work/Papers and Conferences/spatial-microsim-r-course"
local path "`where'/spatial-microsim-book-git/fractional_weights" 

insheet using "`path'/final_micro_fractional_cakes_geo.csv", clear

* create 'dummy' variables ready to collapse to weighted frequencies
gen NCakes_rare = 0
replace NCakes_rare = 1 if ncakes == "rarely"

gen NCakes_l1 = 0
replace NCakes_l1 = 1 if ncakes == "<1"

gen NCakes_1_2 = 0
replace NCakes_1_2 = 1 if ncakes == "1-2"

gen NCakes_3_5 = 0
replace NCakes_3_5 = 1 if ncakes == "3-5"

gen NCakes_6m = 0
replace NCakes_6m = 1 if ncakes == "6+"

* keep the data in memory
* immediately obvious = stata's inability to hold 2 or more datasets at a time!
preserve
* collapse cakes by zone
* this is what the weighted agregate in R should do
collapse (sum) NC* [iw=weight], by(zone_name)

* list first 5 lines as a check
li in 1/5

* save the results so we can add to a map
outsheet using "`path'/cakes_geo.csv", comma replace

* put the data back so we can do other stuff
restore
