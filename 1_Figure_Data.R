#install.packages('devtools')
#devtools::install_github('jfq3/ggordiplots')


# Setup -------------------------------------------------------------------

library(adehabitatHS)
library(data.table)
library(ggordiplots)
library(magrittr)

source('enfa_functions.R')
#imports mag(), ExtractVectors(), ExtractHull(), HistData()

acronyms <- c( 'Urobel','Marfla', 'Callat')
species_names <- c("Belding's Ground Squirrel", 'Yellow-bellied Marmot', 
                   'Golden Mantled Ground Squirrel')

# Read In -----------------------------------------------------------------

#Elise Generated Data

# defines which variables correspond to which number/ID labels for the vectors
key <- fread('data/VariableKey.csv') 

#Contains the position shifts for each of the vector labels so you can see them
nudge <- fread('data/NudgeLabelPositions.csv') 


#Model Generated Data

#reads in ENFA Models, This comes from Chapter1_ENFA script 5_ENFA.R for each species
modlist <- lapply(acronyms, function(n) {
  readRDS(paste0('data/', n, '_ENFA_model_output.RDS'))
})

# Calculations ------------------------------------------------------------

#Fig 2 - Extracts ENFA scores from model
scores <- lapply(1:length(acronyms), function(i) {
  HistData(modlist[[i]], species_names[i])
}) %>% rbindlist()


#Fig 3 - calculates marginality point (centroid of niche space) for each species
marginality <- lapply(1:length(modlist), function(i) {
  data.table(Species=species_names[i], x=mag(modlist[[i]]$mar), y=0)
}) %>% rbindlist()

#dummy column so marginality points are all the same color
marginality[, Fill:='Marginality']


#Fig 3 - calculates the vertices of the niche spaces to plot
hulls <- lapply(1:length(modlist), function(i) {
  ExtractHull(modlist[[i]], species_names[i])
}) %>% rbindlist()

#Fig 3 - calculates the values of the marginality vectors
vects <- lapply(1:length(modlist), function(i) {
  ExtractVectors(modlist[[i]], key, nudge, acronyms[i], species_names[i])
}) %>% rbindlist()



# Save data ---------------------------------------------------------------

fwrite(scores, 'data/Enfa_Scores_fig2.csv')

fwrite(hulls, 'data/Hulls_fig3.csv')
fwrite(vects, 'data/Vectors_fig3.csv')
fwrite(marginality, 'data/MarginPts_fig3.csv')


