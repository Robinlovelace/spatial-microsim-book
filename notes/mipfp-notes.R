# mipfp to do spatial microsimulation without input data

global = read.delim("data/Belgium/BelgiqueConting.txt")
c1 = read.delim("data/Belgium/ContrainteAge.txt")
c2 = read.delim("data/Belgium/ContrainteDipl.txt")
c3 = read.delim("data/Belgium/ContrainteStatut.txt")
c4 = read.delim("data/Belgium/ContrainteGenre.txt")

# for one zone
global_cons = xtabs(Freq ~ gener + dipl + statut + sex, data = global)

i = 1 # zone number
uz = unique(c1$com)
z = uz[i]
z = "92094"
# data preparation
age = c1$COUNT[c1$com == z]
edu = c2$COUNT[c2$com == z]
ocu = c3$COUNT[c3$com == z]
sex = c4$COUNT[c4$com == z]

target = list(
  age,
  edu,
  ocu,
  sex
  )
descript = list(1, 2, 3, 4)

res = mipfp::Ipfp(seed = global_cons,
                  target.list = descript,
                  target.data = target)
identical(dimnames(res$x.hat), dimnames(global_cons))
expa = as.data.frame.table(res$x.hat)

truncated = expa
truncated$COUNT = floor(expa$Freq)
p = expa$Freq - truncated$COUNT
n_missing = sum(p)
index = sample(1:nrow(truncated),
               size = n_missing,
               prob = p,
               replace=FALSE)
truncated$COUNT[index] = truncated$COUNT[index] + 1

int_expand_vector <- function(x){
  index <- 1:length(x)
  rep(index, round(x))
}

exp_indices = int_expand_vector(truncated$COUNT)
synth = expa[exp_indices,]

# for many zones