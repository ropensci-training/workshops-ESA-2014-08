
## ----global plot---------------------------------------------------------
library(spocc)
bbox <- c(-80.79,38.64,-69.62,45.56)
### Searching for sugar maples in New England
out <- occ(query='Acer saccharum', from=c('inat','gbif'), geometry=bbox, limit = 100)
plot(out)


## ----ggplot--------------------------------------------------------------
mapggplot(out)


## ----ggplot custom-------------------------------------------------------
library(maps)

states <- map_data("state")
n_east <- subset(states, region %in% c("vermont","new hampshire","new york","connecticut","pennsylvania","new jersey","rhode island","massachusetts","maryland"  ) )
ne_map <- ggplot() +geom_polygon(data = n_east,aes(x=long,y=lat,group = group), colour="white",fill="grey60") + theme_bw()
ne_map
### Add points
ne_map + geom_point(data = occ2df(out),aes(x=longitude,y=latitude))


## ----ggplot custom 2-----------------------------------------------------
# Redo search adding extra species
out <- occ(query=c('Acer saccharum','Acer rubrum'), from=c('gbif'), geometry=bbox, limit = 150)

ne_map + geom_point(data = occ2df(out),aes(x=longitude,y=latitude, group= name, colour = name, size = 1.5)) + scale_size(guide=F) + scale_colour_manual(values=c("red","blue"))



## ----leaflet-------------------------------------------------------------
out <- occ(query=c('Acer saccharum'), from=c('gbif'), geometry=bbox, limit = 150)
out <- occ2df(out)
mapleaflet(data = out, dest = ".")



## ----geojson-------------------------------------------------------------
out <- occ(query=c('Acer saccharum','Acer rubrum'), from='gbif',gbifopts = list(hasCoordinate=TRUE))
out <- fixnames(out)
out <- occ2df(out)
mapgist(data=out, color=c("#00ff00","#ff00ff"))



