
## ----load, message=FALSE, warning=FALSE----------------------------------
library(spocc)


## ----sources, message=FALSE, warning=FALSE-------------------------------
out <- occ(query='Accipiter striatus', from='gbif')
out # prints summary of output data
out$gbif # GBIF data w/ metadata
out$ebird$data # empty
out$gbif$meta #  metadata, your query parameters, time the call executed, etc. 
out$gbif$data # just data


## ----manysources, message=FALSE, warning=FALSE---------------------------
out <- occ(query='Accipiter striatus', from=c('gbif','bison'))
out # See the summary with each source
out$gbif$data
out$bison$data


## ----multiple species, message=FALSE, warning=FALSE----------------------
out <- occ(query=c('Accipiter striatus',"Accipter cooperii","Buteo jamaicensis"), from=c('inat','bison'))
out <- occ2df(out) # See the summary with each source
head(out)
tail(out)


## ----bounding box--------------------------------------------------------
bbox <- c(-80.79,38.64,-69.62,45.56)
### Searching for sugar maples in New England
out <- occ(query='Acer saccharum', from=c('inat','gbif'), geometry=bbox, limit = 100)



## ----taxize 1------------------------------------------------------------
library(taxize)
comm_splist <- c("Sugar maple","Red maple","Silver maple")
splist <- comm2sci(comm_splist,db='ncbi',simplify=TRUE)
out <- occ(query=unlist(splist), from=c('inat','gbif'), geometry=bbox, limit = 100)
out


## ----taxize 2------------------------------------------------------------
bees <- col_downstream(name="Apis", downto="Species")
### Check the form
bees
out <- occ(query=bees$Apis$childtaxa_name, from=c('bison','gbif'), geometry=bbox, limit = 100)
out <- occ2df(out)
unique(out$name)



