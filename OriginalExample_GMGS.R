library(rgdal)
library(raster)
RandPt <- shapefile("E:/GISData/AlpineMammals/NicheAnalysis/RandPoints/RandptsSNV.shp")
str(RandPt)
names(RandPt)
names(RandPt)[8] <- "NDVIsint"
names(RandPt)[9] <- "NDVImax"
RandPt$Covertype <- NULL
RandPt$Water <- NULL
str(RandPt)
gmgs <- shapefile("E:/GISData/AlpineMammals/NicheAnalysis/Locations/Transects/Spelat/SpelatCoordsSNV.shp")
gmgs

Elevation <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Topography/elevation.tif") 
Slope <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Topography/slope.tif") 
TRI <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Topography/tri.tif") 
PRR <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Topography/prr.tif") 
Hillshade <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Topography/hillshade.tif") 
NDVIsint<- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/NDVI/ndvisint.tif") 
NDVImax <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/NDVI/ndvimax.tif") 
Precip0609 <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Climate/Precip/precip0609.tif")
Precip0609

Precip1005 <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Climate/Precip/precip1005.tif")
Tmin01<- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Climate/Temp/Tmin01.tif") 
Tmax07 <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Climate/Temp/Tmax07.tif") 
Tmax07
Snow <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Climate/Snow/snowdays.tif")

Aspen <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Vegetation/aspen.tif") 
Conifer <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Vegetation/conifer.tif") 
Meadow <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Vegetation/meadow.tif") 
Mixed <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Vegetation/mixed.tif") 
Rock <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Vegetation/rock.tif") 
Shrub <- raster("E:/GISData/AlpineMammals/NicheAnalysis/HabitatData/Vegetation/shrub.tif") 

elevation <- Elevation
elevation
slope <- Slope
tri <- TRI
prr <- PRR
hillshade <- Hillshade
ndvisint <- resample(NDVIsint, elevation)
ndvimax <- resample(NDVImax, elevation)
ppt0609 <- Precip0609
ppt1005 <- Precip1005
tmin01 <- resample(Tmin01, elevation)
tmax07 <- resample(Tmax07, elevation)
snow <- Snow
aspen <- resample(Aspen, elevation)
conifer <- resample(Conifer, elevation)
meadow <- resample(Meadow, elevation)
mixed <- resample(Mixed, elevation)
rock <- resample(Rock, elevation)
shrub <- resample(Shrub, elevation)

compareRaster(elevation, aspen)

library(raster)

GMGSStack <- stack (elevation, slope, tri, prr, hillshade, ndvisint, ndvimax,
 ppt0609, ppt1005, tmin01, tmax07, snow, aspen, conifer, meadow, mixed, rock,
 shrub)

nlayers(GMGSStack)

proper <- function(x) {
 s <- strsplit(x," ")[[1]]
 paste(toupper(substring(s, 1,1)), substring(s, 2), sep="", collapse=" ")
}

var.names.x <- names(MarmotStack)
var.names <- var.names.x
for(i in 1:length(var.names.x)) {
 var.names.i <- proper(var.names.x[i]) 
 var.names[i] <- var.names.i
}
var.names
var.names[3] <- "TRI"
var.names[4] <- "PRR"
var.names[6] <- "NDVIsint"
var.names[7] <- "NDVImax"
var.names[12] <- "Snow"
var.names

GMGSStack
names(GMGSStack) <- var.names
GMGSStack

HabitatVariablesgmgs <- extract(GMGSStack, gmgs)
HabitatVariablesgmgs

HabitatVariablesgmgs.dfm <- data.frame(HabitatVariablesgmgs)
str(HabitatVariablesgmgs.dfm)
colnames(HabitatVariablesgmgs.dfm) <- var.names
str(HabitatVariablesgmgs.dfm)

gmgs.coords <- data.frame(coordinates(gmgs))
colnames(gmgs.coords) <- c("UTMEW", "UTMNS")
str(gmgs.coords)
nrow(unique(gmgs.coords))

habvarsgmgs <- cbind(gmgs.coords, HabitatVariablesgmgs.dfm)
str(habvarsgmgs)

write.csv(habvarsgmgs, file = "HabitatVariablesgmgs.csv")

library(adehabitatHS)
library(adehabitatMA)
library(vegan)
library(raster)
library(sp)
library(maptools)

#==============================================================================
# Niche factor analysis based on spatial locations of Marmot collected along 21
# transects in the Sierra Nevada from 2009 - 2012. In addition to 1703
# locations ("used points") 50,000 random points were generated as "available
# locations". Values of thirteen habitat variables were extracted for each point.
# The available points were then filtered for elevations > 2500 m (about 8500
# feet). 
#==============================================================================

gmgshabvars.temp <- habvarsgmgs
str (gmgshabvars.temp)
summary (gmgshabvars.temp)

gmgshabvars.temp2 <- gmgshabvars.temp
str(gmgshabvars.temp2)

# Available habitat
names(RandPt@data)
names(gmgshabvars.temp2)

# Combine used and available habitat 
gmgshabvars.temp3 <- rbind(gmgshabvars.temp2, RandPt@data)
str(gmgshabvars.temp3)

gmgshabvars <- gmgshabvars.temp3
str(gmgshabvars)
names(gmgshabvars)[1] <- "gmgs"
gmgshabvars$gmgs <- 0
gmgshabvars$gmgs[1:nrow(habvarsgmgs)] <- 1
gmgshabvars$UTMNS <- NULL
str(gmgshabvars)

gmgs.pa <- gmgshabvars$gmgs
gmgs.pa
gmgshabvars$gmgs <- NULL
str(gmgshabvars)

str(gmgshabvars)


gmgshabvars$shrub <- gmgshabvars$shrub + gmgshabvars$aspen + gmgshabvars$mixed
gmgshabvars$aspen
gmgshabvars$mixed
gmgshabvars$shrub
gmgshabvars$Aspen <- NULL
gmgshabvars$Mixed <- NULL

cor(gmgshabvars)
str(gmgshabvars)

weights <- gmgs.pa


str(weights)

histniche(gmgshabvars, weights)
          
habavail.pca <- dudi.pca(gmgshabvars, scannf=FALSE)

marmot.gn <- gnesfa(habavail.pca, Focus=weights, centering="single", nfFirst=1, nfLast=1, scannf=FALSE)
marmot.gn
marmot.gn$cor

scatterniche(marmot.gn$li, weights, pts=TRUE)
s.arrow(marmot.gn$co)
s.arrow(marmot.gn$cor)
marmot.mad <- madifa(habavail.pca, weights, scan=FALSE)
marmot.mad

# li is like coordinates to plot in multivariate space
scatterniche(marmot.mad$li, weights, pts=TRUE)
s.arrow(marmot.mad$co)
s.arrow(marmot.mad$cor)

#Gray is available.  Black is used.  X axis is marginality, y axis is specialization.  

# Niche factor analysis (ENFA; used habitat is the Focus group)
#This is the third NFA, and the one Rob finds most useful.
#This one explicitly discriminates between marginality and specialization
marmot.enfa <- enfa(habavail.pca, weights, scan=FALSE)
marmot.enfa
# co shows how important that variable is loading for the 1st and 2nd.  The li is the actual coordinate of the variable in multivariate space.  
marmot.enfa$co
hist(marmot.enfa, type="h")
scatter(marmot.enfa)
scatter(marmot.enfa, nc=T, percent=95, clabel=0, Acol="green", Ucol="blue",
 side="none", Aborder="black", Uborder="black")
scatterniche(marmot.enfa$li, weights)
s.arrow(marmot.enfa$co)
marmot

#==============================================================================
# Graph of used vs. availability locations from the PCA
#==============================================================================

str(habavail.pca)
pcacols <- rep("green", nrow(habavail.pca$li))
pcacols[weights > 0] <- "blue"
ua.fac.avail <- rep("Available", length(weights))
ua.fac.used <- rep("Available", length(weights))
ua.fac.used[weights > 0] <- "Used"
plot(habavail.pca$li, pch=21, bg=pcacols, cex=0.5, xlim=c(-10,10), ylim=c(-9,11),
 xlab="Axis 1", ylab="Axis 2", cex.main=0.9,
 main="gmgs - Sierra Nevada Core Landscape\nPCA")
ordihull(habavail.pca$li, groups=ua.fac.avail, draw="lines", col="green",
 lwd=2)
ordihull(habavail.pca$li, groups=ua.fac.used, show.groups="Used", col="blue",
 draw="lines", lwd=3)
legend(7,0, legend=c("Available","Used"), pch=21, pt.bg=c("green","blue"),
 cex=0.9, box.lty=0)

