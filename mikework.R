#Capitolwords group project - Mike's work

#Original loop code from class
install.packages(devtools)
library(devtools)
install_github("govdat","cocteau")
library(govdat)
for(i in 1:nrow(senate)){
  tmp = sll_cw_phrases("legistlator", senate$id[i], key = "6a0998f8ba3c4a8b888ef28b20975174")
  print(paste(senate$last_name[i], tmp$ngram[1]))
}


#Attempt at making timeseries loop. Emailed mark.
for(i in 1:nrow(senate)){
  tmp = sll_cw_timeseries("drones", "1996-01-01", "2013-11-22", senate$id[i], key = "6a0998f8ba3c4a8b888ef28b20975174")
  print(paste(senate$last_name[i], tmp$ngram[1]))
}


#Creates ggplot of word 'drone' over time sorted by party.
install.packages(ggplot2)
library(ggplot2)
dat_d <- sll_cw_timeseries(phrase='drones', party="D", key = "6a0998f8ba3c4a8b888ef28b20975174")
dat_d$party <- rep("D", nrow(dat_d))
dat_r <- sll_cw_timeseries(phrase='drones', party="R", key = "6a0998f8ba3c4a8b888ef28b20975174")
dat_r$party <- rep("R", nrow(dat_r))
dat_both <- rbind(dat_d, dat_r)
ggplot(dat_both, aes(day, count, colour=party)) + geom_line() +
  theme_grey(base_size=20) + scale_colour_manual(values=c("blue","red"))