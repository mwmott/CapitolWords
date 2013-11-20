#Load govdat
library(govdat)
#Load dataset senate
senate = read.csv("http://compute-cuj.org/data2/day1/nyt_senate.csv", as.is=TRUE)
#loop
for(i in 1:nrow(senate)){
  tmp = sll_cw_phrases("legislator",senate$id[i],key="b1884b38a7e04ffeb9bdc91a0a63fe1b")
  print(paste(senate$last_name[i], tmp$ngram[1]))
}

sll_cw_phrases("legislator","B001261",key="b1884b38a7e04ffeb9bdc91a0a63fe1b")

congress
