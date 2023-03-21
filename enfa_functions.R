mag <- function(x) {
  # calcualates the length of a n-dimensional vector (x)
  return(sqrt(sum(x^2)))
}


GetVars <- function(mod) {
  #mod - enfa, ENFA model, created using enfa() from adehabitatHS package
  #returns the names of the variables that were fed into an ENFA analysis
  return(names(mod$mar))
}

ExtractVectors <- function(mod, id_key, nudge, acronym, species, scalar=5) {
  #Extracts data to plot vector arrows from the ENFA analysis
  
  #enfa    ENFA model, created using enfa() from adehabitatHS package
  #id_key  data.frame, containing the IDs for each variable in the ENFA model
  #nudge   data.frame, containing nudge values for the labels of each variable 
  #acronym chr, species acronym, Marfla, Callat or Urobel
  #species chr, species common name
  #scalar  numeric, what to multiply the vectors by so they are on the same scale
    #as the niche space hulls
  
  coords0 <- mod$co #extract vectors from the model
  
  coords0$Variable <- row.names(coords0) #turn variable names into a column
  coords <- merge(coords0, id_key, by='Variable') #add IDs
  
  #calculate magnitude of each vector (not currently used)
  coords$Magnitude <- sapply(1:nrow(coords), function(i) mag(coords[i, c('Mar', 'Spe1')]))
  
  #scale vectors by scalar value
  coords$x <- coords$Mar*scalar
  coords$y <- coords$Spe1*scalar
  
  #identify the data by which species it comes from
  coords$Acronym <- acronym
  coords$Species <- species
  
  #add the amount each label should be displaced from the point
  coords <- merge(coords, nudge, by=c('Acronym', 'Variable'))
  
  #calculate total position of text labels
  coords$text_x <- (coords$x + coords$x_nudge)
  coords$text_y <- (coords$y + coords$y_nudge)
  
  return(coords)
}

ExtractHull <- function(mod, species) {
  #Calculates points to create hull polygon in a plot
  
  #mod      ENFA model, created using enfa() from adehabitatHS package
  #species  chr, common name of the species
  
  #extract presence/available weights from the model
  w <- mod$pr
  
  #create Available/Used vector
  ua.fac.used <- rep("Available", length(w))
  ua.fac.used[w > 0] <- "Used"
    
  #calculate polygon data points
  hull <- gg_ordiplot(mod$li, groups = ua.fac.used, plot=FALSE)$df_hull
  hull$Species <- species #add species name for labeling
  
  return(hull)
}


  
EnfaBiplot <- function(mod, id_key, species, lab_pos, offset=0.3, 
                       plot_legend=TRUE, return_data=FALSE) {
  #Creates a biplot of an ENFA model. This includes both the polygons that 
  #encompass the available and used niche space and the vector arrows from the 
  #variables in the model. As a note, this only plots one species. if you 
  #want to plot all three together you need to use par(mfrow=c(3,1)) and then
  #run the function 3 times, each for a different species.
  
  #mod          ENFA model, created using enfa() from adehabitatHS package
  #id_key       data.frame, contains the ID numbers for each variable in the model
                  #is saved in data/VariableKey.csv
  #species      character, common name of the species
  #lab_pos      integer, vector specifying the direction of the offset of the label 
                  #from the vector data point. length = number of variables in
                  #model. 1=below, 2=to the left, 3=above, 4=to the right. See `pos`
                  #argument of text() help page.
  #offset       numeric, the amount the label is offset from the point in the direction
                  #specified by lab_pos. See `offset` argument of text() help page
  #plot_legend  logical, should the legend be included in the plot?
  #return_data  logical, should the dataset be returned for later use?

  
  #extract presence/available weights from the model
  w <- mod$pr
  
  #create vector that is 'Available' and 'Used' instead of 0 and 1
  ua.fac.avail <- rep("Available", length(w))
  ua.fac.used <- rep("Available", length(w))
  ua.fac.used[w > 0] <- "Used"
  
  coords0 <- mod$co #extract marginality and specialization dataframe from model
  
  coords0$Variable <- row.names(coords0) #add variable labels as a column
  
  #add ID number labels to the data.frame
  coords <- merge(coords0, id_key, by='Variable')
  
  #calculate the magnitude of each vector, this is not necessary to run the model
  #it just helped Elise tell which arrow corresponded to each variable when she was
  #creating the labels
  coords$Magnitude <- sapply(1:nrow(coords), function(i) mag(coords[i, c('Mar', 'Spe1')]))
  
  #sort variables by ID
  coords <- coords[order(as.numeric(coords$ID)),]
  
  #add position offset directiosn to data
  coords$Pos <- lab_pos
  
  #create a plot window of the right size and with the correct labels but 
  #without any visible points (cex=0)
  plot(mod$li, pch=21, cex=0, xlim=c(-6,6), ylim=c(-6,4),
       xlab="Marginality", ylab="Specialization", cex.main=1.1,
       main=paste0(species))
  
  #add the 'Available' niche space polygon
  ordihull(mod$li, groups=ua.fac.avail, show.groups="Available", col="#d95f02",
           lwd=2)
  
  #Add the 'Used' niche space polygons
  ordihull(mod$li, groups=ua.fac.used, show.groups="Used", col="#7570b3", lwd=2)
  
  #add the vector arrows, values are multiplied by 5 so they show up on the plot
  #which is okay because we only care about the relative size, not the absolue size
  arrows(0,0, coords$Mar*5, coords$Spe1*5, length=0.05, angle=30)
  
  #add ID labels
  text(coords[,c('Mar', 'Spe1')]*5, labels=coords$ID, cex=0.6, pos=coords$Pos,
       offset=offset)
  
  #add marginality point
  points(mag(mod$mar), 0, pch=21, bg="#1b9e77", cex=1.5)
  
  #add dashed horizontal and vertical lines
  abline(h=0, v=0, lty=3)
  
  if (plot_legend) {
    #add legend for Available and Used polygon lines
    legend(2,-2, legend=c("Available","Used"), lty=1, 
           col=c("#d95f02", "#7570b3"),
           lwd=2, cex=0.8, box.lty=0, title.cex=1.2,
           title='Niche Space')
    
    #add legend for marginality point
    legend(2.25,-3.4, legend=c("Marginality"), pch=21, 
           pt.bg= "#1b9e77", cex=0.8, box.lty=0, pt.cex=1.5)
  }
  
  if (return_data) {
    return(coords)
  }
}

HistData <- function(mod, species) {
  #Extracts data from ENFA model used to plot histogram 
  
  #mod      ENFA model, created using enfa() from adehabitatHS package
  #species  chr, common name of the species
  
  #extract presence/available weights from the model
  w <- mod$pr
  
  #extract marginality and specialization from the model and standardize number
  #of digits printed
  mar <- formatC(round(mod$m, 2), format = 'f', flag='0', digits = 2)
  spe <- formatC(round(mod$s[1], 2), format = 'f', flag='0', digits = 2)
  
  dt <- data.table(mod$li) #Extract points from the model
  dt[,Weights:=w] #assign each point a weight

  #creating a data frame with available habitat (including used)
  dt_avail <- copy(dt) 
  dt_avail[, AU:='Available']
  
  #creating a dataframe with only used habitat
  dt_used <- copy(dt[Weights==1])
  dt_used[, AU:='Used']
  
  #creating a dataframe with all habitat
  dt_all <- rbind(dt_avail, dt_used)
  
  #go from wide to long data
  dt_long <- melt(dt_all, id.vars=c('AU', 'Weights'), variable.factor = FALSE)
  
  #add species name for labelling plots
  dt_long[, Species:=species]
  
  #create labels for headers
  facetdt <- data.table(variable=c('Mar', 'Spe1'), 
                        facetvar=c(paste0('Marginality - ', mar), 
                                   paste0('Specialization - ', spe)))
  
  #add header labels to final data.
  final <- merge(dt_long, facetdt, by='variable')
  
  return(final)
  
}

