# Capitolwords group project - Mike, Alex, Brian

# In our second attempt of tackling the CapitolWords API project, 
# we worked through timeseries' of the top users of the word "drone." 
# We found 20 top users, did an example timeseries for one, and also
# did a ggplot of all the users over time and a timeseries for all 
# occurences of "drone" for context.

# We then worked to figure out how to do it as a loop for all 20 of them. 
# Currently we are stuck on that loop, the error message for which is below.

# Mark helped us create dotchart also to better see our data, which shows
# the word drone said over time sorted by the last time speakers said it.
# Our goal from here on is to look at that chart, find interesting outliers
# and figure out if there are connections between those who spoke the most 
# about drones, those who sponsor bills, and those who are being paid in
# campaign contributions by top drone manufacturers.

# "Drone" word in congressional record since '96
dronets= sll_cw_timeseries("drone",key="b1884b38a7e04ffeb9bdc91a0a63fe1b")
plot(dronets$day,dronets$count)

# ggplot of word 'drone' over time, sorted by party.
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

# Original loop code from class
install.packages(devtools)
library(devtools)
install_github("govdat","cocteau")
library(govdat)
for(i in 1:nrow(senate)){
  tmp = sll_cw_phrases("legislator", senate$id[i], 
                       key = "6a0998f8ba3c4a8b888ef28b20975174")
  print(paste(senate$last_name[i], tmp$ngram[1]))
}

# Attempt at making timeseries loop. To be added to from Alex.
for(i in 1:nrow(senate)){
  tmp = sll_cw_timeseries("drones", senate$id[i], 
                          key = "6a0998f8ba3c4a8b888ef28b20975174")
  print(paste(senate$last_name[i], tmp$ngram[1]))
}

# Show top legislators who use the word drone - from here we might be able 
# to see whether they stopped. Later we used the dotchart to better visualize this. 
topdroneusers=sll_cw_entity_phrases(entity="legislator",phrase='drone',sort="count",key="b1884b38a7e04ffeb9bdc91a0a63fe1b")

# We noticed the top legislator to use "drone is Rand Paul, bioguide - P000603. 
# The only time he said the word drone was on March 6th, where he said it 235 
# times in a filibuster against Obama, whom he claimed was advocating for a drone 
# strike program within the U.S.
sll_cw_timeseries("drone", bioguide_id="P000603", "1996-01-01","2013-11-22", key="b1884b38a7e04ffeb9bdc91a0a63fe1b")

# Top 20 users of word drones w/ numbers
print(paste(topdroneusers$legislator[i],topdroneusers$count[1:20]))

# Top 20 drone users - just the bioguides
top20 = paste(topdroneusers$legislator[1:20])

# Loop baby! Just need to figure out how to see them all at once.
for(i in topdroneusers$legislator[1:20]){
  ts= sll_cw_timeseries("drone", bioguide_id=i, "1996-01-01","2013-11-22", key="b1884b38a7e04ffeb9bdc91a0a63fe1b")
  plot(ts$day,ts$count)
}

# Also experimented for future use with working with drone legislation using OpenStates API:

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