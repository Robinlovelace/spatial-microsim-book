# Transform con1 into an 3D-array : con1_convert

names <- c(list(rownames(cons)),dimnames(weight_init)[c(4,6)])
con1_convert <- array(NA, dim=c(nrow(cons),2,6), dimnames = names)

for(zone in rownames(cons)){
  for (sex in dimnames(con1_convert)$Sex){
    for (age in dimnames(con1_convert)$ageband4){
      con1_convert[zone,sex,age] <- con1[zone,paste(sex,age,sep="")]
    }
  }
}

# check margins per zone: 
table(rowSums(con1)==apply(con1_convert, 1, sum))