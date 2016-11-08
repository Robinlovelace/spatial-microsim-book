## Notes on simPop
# install.packages("simPop")
library(simPop)
data(eusilcS)
nrow(eusilcS) /
  length(unique(eusilcS$db030))
inp = specifyInput(data = eusilcS,
                   hhid = "db030",
                   hhsize = "hsize",
                   strata = "db040",
                   weight = "rb050")
data("totalsRG")
tt = xtabs(Freq ~ ., totalsRG)
# tableWt()
class(tt) = "table"
oldweights = inp@data$rb050
addWeights(inp) = calibSample(inp, totals = tt)
newweights = inp@data$rb050
plot(oldweights, newweights)
synthP = simStructure(dataS = inp,
                      method = "direct",
                      basicHHvars = c("age", "rb090", "db040"))
s = synthP@pop@data

# with SimpleWorld
ind = read.csv("data/SimpleWorld/ind-full.csv")
ind$hhid = sample(x = 1:3, size = nrow(ind), replace = T)
ind$strata = sample(x = 1:3, size = nrow(ind), replace = T)
ind$weight = 1
i = specifyInput(ind, hhid = "hhid", pid = "id", strata = "strata", weight = "weight")
con1 = read.csv("data/SimpleWorld/sex.csv")
tots = data.frame(sex = c("m", "f"),
                  Freq =colSums(con1))
ti = xtabs(Freq ~ ., tots)
class(ti) = "table"
addWeights(i) = calibSample(i, ti)
s = simStructure(i, "direct", c("age", "sex", "hhid"))
s_data = s@pop@data
head(s_data)
