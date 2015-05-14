dir.create("data/hawaii")
download.file("http://www2.census.gov/census_2000/datasets/PUMS/OnePercent/Hawaii/revisedpums1_15.txt", destfile = "data/hawaii/pums_15.dat")
download.file("http://www2.census.gov/census_2000/datasets/PUMS/OnePercent/Hawaii/PUMEQ1-HI.TXT", destfile = "data/hawaii/pum.txt")

hawaii <- read.delim("data/hawaii/pums_15.dat", strip.white = T, header = F)
hawaii <- read.delim("~/Desktop/pums_15.dat", sep = " ", header = F)

head(hawaii)

