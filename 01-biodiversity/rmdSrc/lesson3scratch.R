
devtools::install_github("prism", "ropensci")
library(prism)
options(prism.path = "~/prismtmp")
get_prism_normals(type="tmean", annual=TRUE, resolution = "4km",keepZip=F)
ls_prism_data()
prism_image(ls_prism_data()[1])
prismfile <- ls_prism_data(absPath=T)[1]
unprojDep <- raster(prismfile)
projDep <- projectRaster(from = unprojDep,crs=" +init=EPSG:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 ")
plot(projDep)
points(out_df$longitude,out_df$latitude)

splist <- c("Acer saccharum", "Abies balsamea", "Arbutus xalapensis", "Betula alleghaniensis", "Chilopsis linearis", "Conocarpus erectus", "Populus tremuloides", "Larix laricina")
out <- occ(query = splist, from = c("bison"), limit = 100)

## scrub names
out <- fixnames(out, how = "query")

## Create a data frame of all data.

out_df <- occ2df(out)

cname <- ldply(sci2comm(get_tsn(splist), db = "itis", simplify = TRUE), function(x) { return(x[1]) })[, 2]

sp_points <- occ_to_sp(out)

mtemp <- rep(NA,length(splist))
mlat <- rep(NA,length(splist))
for (i in 1:length(splist)) {
  tmp_sp <- sp_points[which(sp_points$name == splist[i]), ]
  mtemp[i] <- mean(unlist(extract(projDep,tmp_sp,buffer = 100)),na.rm=T)
  mlat[i] <- mean(coordinates(tmp_sp)[,2])
}
df <- data.frame(cbind(mtemp,mlat))
df$name <- cname
ggplot(df, aes(x = mlat, y = mtemp, label = name)) +
  geom_text() +
  xlab("Mean Latitude") +
  ylab("Mean Temperature (C)") +
  theme_bw() +
  xlim(15, 50)
