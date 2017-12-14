# mipfp to do spatial microsimulation without input data

global = read.delim("data/Belgium/BelgiqueConting.txt")
in_age = read.delim("data/Belgium/ContrainteAge.txt")
in_dip = read.delim("data/Belgium/ContrainteDipl.txt")
in_sta = read.delim("data/Belgium/ContrainteStatut.txt")
in_sex = read.delim("data/Belgium/ContrainteGenre.txt")

# for one zone
global_cons = xtabs(Freq ~ gener + dipl + statut + sex, data = global)

i = 1 # zone number
uz = unique(in_age$com)
z = uz[i]
z = "92094"
# data preparation
age = in_age$COUNT[in_age$com == z]
edu = in_dip$COUNT[in_dip$com == z]
ocu = in_sta$COUNT[in_sta$com == z]
sex = in_sex$COUNT[in_sex$com == z]

target = list(age, edu, ocu, sex)
descript = list(1, 2, 3, 4)

res = mipfp::Ipfp(global_cons, descript, target)
identical(dimnames(res$x.hat), dimnames(global_cons))
expa = as.data.frame.table(res$x.hat)

# Integerisation, see here for code:
# https://github.com/Robinlovelace/spatial-microsim-book/blob/master/R/functions.R
source("code/functions.R") # loads functions into memory
expa$int = int_trs(expa$Freq)
exp_indices = int_expand_vector(expa$int)
synth = expa[exp_indices,]

# for many zones
list_output = vector(mode = "list", length = length(uz))
for(i in 1:length(uz)) {
  z = uz[i]
  # data preparation
  age = in_age$COUNT[in_age$com == z]
  edu = in_dip$COUNT[in_dip$com == z]
  ocu = in_sta$COUNT[in_sta$com == z]
  sex = in_sex$COUNT[in_sex$com == z]
  target = list(age, edu, ocu, sex)
  res = mipfp::Ipfp(global_cons, descript, target)
  expa = as.data.frame.table(res$x.hat)
  expa$int = rakeR::integerise(expa$Freq)[,1]
  exp_indices = int_expand_vector(expa$int)
  list_output[[i]] = expa[exp_indices,]
}

synth_namur = dplyr::bind_rows(list_output, .id = "id")
library(dplyr)
pmale = group_by(synth_namur, id) %>% 
  summarise(pmale = sum(sex == "Hommes") /
              n())
