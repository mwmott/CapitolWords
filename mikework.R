# Capitolwords group project - Mike's work

# Original loop code from class
install.packages(devtools)
library(devtools)
install_github("govdat","cocteau")
library(govdat)
for(i in 1:nrow(senate)){
  tmp = sll_cw_phrases("legistlator", senate$id[i], 
                       key = "6a0998f8ba3c4a8b888ef28b20975174")
  print(paste(senate$last_name[i], tmp$ngram[1]))
}


# Attempt at making timeseries loop. Emailed mark.
for(i in 1:nrow(senate)){
  tmp = sll_cw_timeseries("drones", "1996-01-01", "2013-11-22", senate$id[i], 
                          key = "6a0998f8ba3c4a8b888ef28b20975174")
  print(paste(senate$last_name[i], tmp$ngram[1]))
}

# drones and drone plots since '96
dronets= sll_cw_timeseries("drone","1996-01-01","2013-11-22", 
                           key="b1884b38a7e04ffeb9bdc91a0a63fe1b")
# 134 records returned
dronests= sll_cw_timeseries("drones","1996-01-01","2013-11-22", 
                            key="b1884b38a7e04ffeb9bdc91a0a63fe1b")
# 169 records returned
plot(dronests$day,dronests$count)
plot(dronets$day,dronets$count)

# Creates ggplot of word 'drone' over time sorted by party.
install.packages(ggplot2)
library(ggplot2)
dat_d <- sll_cw_timeseries(phrase='drones', party="D", 
                           key = "6a0998f8ba3c4a8b888ef28b20975174")
dat_d$party <- rep("D", nrow(dat_d))
dat_r <- sll_cw_timeseries(phrase='drones', party="R", 
                           key = "6a0998f8ba3c4a8b888ef28b20975174")
dat_r$party <- rep("R", nrow(dat_r))
dat_both <- rbind(dat_d, dat_r)
ggplot(dat_both, aes(day, count, colour=party)) + geom_line() +
  theme_grey(base_size=20) + scale_colour_manual(values=c("blue","red"))

# Show me top legislators who use the word drone - from here we might be able 
# to see whether they stopped? Also, not sure how to have drones + drone. This 
# is drone.
topdroneusers=sll_cw_entity_phrases(entity="legislator",phrase='drone',sort="count", 
                      key="b1884b38a7e04ffeb9bdc91a0a63fe1b")
# Drones
topdronesusers=sll_cw_entity_phrases(entity="legislator",phrase='drones',sort="count", 
                      key="b1884b38a7e04ffeb9bdc91a0a63fe1b")

# Top legislator is Rand Paul, bioguide - P000603. The only time he said
# the word drone was on March 6th, where he said it 235 times in a filibuster
# against Obama, whom he claimed was advocating for a drone strike program
# within the U.S.
sll_cw_timeseries("drone", bioguide_id="P000603", "1996-01-01","2013-11-22", 
                  key="b1884b38a7e04ffeb9bdc91a0a63fe1b")

# Would like to see from month to month, who's usage of drone/s dropped 
# below 50% of previous value? Or plot all of these?

# Giving top 20 users of word drones w/ numbers
print(paste(topdroneusers$legislator[i],topdroneusers$count[1:20]))

# Top 20 drone users - just the bioguides
top20 = paste(topdroneusers$legislator[1:20])

# Loop baby! Just need to figure out how to see them all at once.
for(i in topdroneusers$legislator[1:20]){
  ts= sll_cw_timeseries("drone", bioguide_id=i, "1996-01-01","2013-11-22", key="b1884b38a7e04ffeb9bdc91a0a63fe1b")
  plot(ts$day,ts$count)
}

# Cool. Going to use lattice/trellis/qq to do this.

# Example plot (https://www.stat.auckland.ac.nz/~ihaka/787/lectures-trellis.pdf)
Depth = equal.count(quakes$depth,number = 8,overlap = .1)
xyplot(lat ~ long | Depth, data = quakes,xlab = "Longtitude", ylab = "Lattitude")

# Trying to work through example plot w/ our data. Not sure where to go from here?
Drones=equal.count(ts$count, number = 20, overlap =.1)
xyplot(ts$count~ts$day | Drones, data=i)

# Experimenting with working with drone legislation using OpenStates API:

#Installing relevant packages/getting JSON
install.packages("rjson")
library(rjson)
install.packages("XML")
library(XML)
url = "openstates.org/api/v1//bills/?q=drone&apikey=b1884b38a7e04ffeb9bdc91a0a63fe1b"
response = getURL(url)
dronebills = fromJSON(response)

# Converting into dataframe. This gives us a list of 62 bills with comma sep. title,
# date, etc. Need to figure out how to convert into more of a df. Function syntax gathered from
# http://stackoverflow.com/questions/6526646/getting-dataframe-directly-from-json-file:
dronebillsdf= as.data.frame(t(sapply(dronebills, unlist)))