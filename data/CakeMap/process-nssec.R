nssecNames <- c("1.1", "1.2", 2:8, "NA") 
nssec <- read.csv("cakeMap/nssec-raw.csv", skip=1)
head(nssec[1:6])
names(nssec)[1:10]
names(nssec) <- gsub(pattern="Age...Age.16.to.74...NS.SeC..National.Statistics.Socio.economic.Classification....", replacement="",
  names(nssec))
names(nssec)
Other <- rowSums(nssec[56:60])
plot(colSums(nssec[7:20]))
(sel <- grep("^[0-9]", names(nssec)))
nssec <- nssec[sel]

# clean up column names
library(stringr)
names(nssec) <- str_split_fixed(names(nssec), "\\.[A-Z]", 2)[,1]
names(nssec) <- gsub("\\.$", "", names(nssec))
head(nssec)

# remove "1" category, add Other
nssec[1] <- NULL
nssec <- cbind(nssec, Other)
head(nssec)
write.csv(nssec, "cakeMap/con3.csv", row.names = F)

