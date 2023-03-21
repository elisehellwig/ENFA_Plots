
# Setup -------------------------------------------------------------------

library(adehabitatHS)
library(data.table)


source('enfa_functions.R')
#imports mag(), EnfaBiplot()

acronyms <- c('Marfla', 'Callat', 'Urobel')
species_names <- c('Yellow-bellied Marmot', 'Golden Mantled Ground Squirrel',
                   "Belding's Ground Squirrel")
# Read In -----------------------------------------------------------------

#data assigning each variable a number ID for labeling
key <- fread('data/VariableKey.csv') 

#reads in ENFA Models
modlist <- lapply(acronyms, function(n) {
  readRDS(paste0('data/', n, '_ENFA_model_output.RDS'))
})

#reads in weights for ENFA Models
weightslist <- lapply(acronyms, function(n) {
  readRDS(paste0('data/', n,'_weights.RDS'))
})


# Create Plot -------------------------------------------------------------

png('Plots/NicheSpaceBiplot_alt.png', width = 1000, height=2000, res=150)

  par(mfrow=c(3,1)) #set figure to have 3 rows and 1 column

  #plot YBM biplot
  EnfaBiplot(modlist[[1]],key, 'Yellow-Bellied Marmot',
                c(3,3,1,3,1,2,2,2,1,3,1,4,1,1))
  
  #GMGS biplot
  EnfaBiplot(modlist[[2]],  key,'Golden Mantled Ground Squirrel',
           c(1,1,3,1,3,2,2,1,4,4,4,4,3,3), plot_legend=FALSE)

  #BGS biplot
  EnfaBiplot(modlist[[3]], key, "Belding's Ground Squirrel",
                c(4,3,1,3,3,4,4,2,2,2,1,4,3,1), plot_legend=FALSE)

dev.off()



# Old code ----------------------------------------------------------------

# marfla <- readRDS('data/Marfla_ENFA_model_output.RDS')
# mar_weights <- readRDS('data/Marfla_weights.RDS')
# 
# callat <- readRDS('data/Callat_ENFA_model_output.RDS')
# cal_weights <- readRDS('data/Callat_weights.RDS')
# 
# urobel <- readRDS('data/Urobel_ENFA_model_output.RDS')
# uro_weights <- readRDS('data/Urobel_weights.RDS')

# #1    #2    #3    #4    #5    #6  #7    #8    #9    #10    #11  #12  #13   #14
# xnudge_urobel <- c( 0.2, -0.2, -0.2, 0.2,    0,  0.1, 0.2, -0.1, -0.2, -0.2,  -0.2, 0.2, -0.3,   0)
# ynudge_urobel <- c(-0.1,  0.2, -0.2, 0.1,  0.2, -0.1, 0.1,  0.2, -0.05, 0.05, -0.1,   0, 0.15, 0.3)
# 
# #1    #2    #3   #4    #5    #6     #7    #8   #9  #10   #11   #12  #13   #14
# xnudge_callat <- c(  0,     0,   0,  0.2, -0.1, -0.2,  -0.2,  0.15, 0.2, 0.2, 0.2,  0.1, -0.2,   0)
# ynudge_callat <- c(-0.2, -0.2, 0.2, -0.1,  0.2, 0.05, -0.05, -0.15,   0,   0, 0.1, 0.15,  0.2, 0.2)
# 
# #1     #2     #3   #4    #5    #6     #7    #8      #9   #10  #11   #12   #13    #14
# xnudge_marfla <- c(0.1, -0.05, -0.05,  0.1, -0.1, -0.2,  -0.2, -0.1,  -0.1, -0.2, -0.2,  0.2,    0, -0.1)
# ynudge_marfla <- c(0.2,   0.2,  -0.2,  0.2, -0.2, 0.05, -0.05,    0, -0.15,  0.1, -0.2, -0.1, -0.2, -0.2)
# 
# nudge_df <- data.frame(Acronym=rep(acronyms, each=14),
#                        Variable=rep(names(marfla$mar), 3),
#                        x_nudge=c(xnudge_marfla, xnudge_callat, xnudge_urobel),
#                        y_nudge=c(ynudge_marfla, ynudge_callat, ynudge_urobel))
# fwrite(nudge_df, 'data/NudgeLabelPositions.csv')

# vars <- unique(c(names(marfla$mar), names(callat$mar), names(urobel$mar)))
# key <- data.frame(Variable=vars, ID=as.character(1:length(vars)))
# fwrite(key, 'data/VariableKey.csv')
