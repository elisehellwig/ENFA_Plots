
# Setup -------------------------------------------------------------------

library(data.table)
library(ggplot2)

#sets colors for distinguishing avaliable vs used niche space
niche_colors <- c('Available'='#d95f02', 'Used'='#7570b3')

#set color for marginality point
margin_color <- c('Marginality'='#1b9e77')

species_names <- c("Belding's Ground Squirrel", 'Yellow-bellied Marmot', 
                   'Golden Mantled Ground Squirrel')


# Read In -----------------------------------------------------------------

#generated in 1_Figure_Data.R
hulls <- fread('data/Hulls_fig3.csv') #niche space polygon data
hulls$Species <- factor(hulls$Species, levels=species_names)

vects <- fread('data/Vectors_fig3.csv') #data for ENFA vectors (arrows)
vects$Species <- factor(vects$Species, levels=species_names)

marginality <- fread('data/MarginPts_fig3.csv') #data for plotting the marginality points
marginality$Species <- factor(marginality$Species, levels=species_names)

# Create Plot -------------------------------------------------------------


bp <- ggplot(data=hulls) + #set first data source
  geom_hline(aes(yintercept=0), linetype='dashed', linewidth=0.2) + #add horizontal dashed line
  geom_vline(aes(xintercept=0), linetype='dashed', linewidth=0.2) + #add vertical dashed line
  
  #add niche space polygons (oka hulls)
  geom_polygon(data=hulls, aes(x=x, y=y, group=Group, color=Group), fill=NA) + 
  
  #add legend for niche space polygon colors
  scale_color_manual(values = niche_colors, name='Niche Space')+
  
  #add vector arrows of each variable in model
  geom_segment(data=vects, aes(x=0, y=0, xend=x, yend=y, group=Variable), 
               lineend = 'butt', linejoin = 'mitre', linewidth=0.3,
               arrow=arrow(length = unit(0.12, "cm"))) +
  
  #add labels to the vector arrows
  geom_text(data=vects, aes(x=text_x, y=text_y, label=ID), size=4) +
  
  #add marginality point to plot
  geom_point(data=marginality, aes(x=x, y=y, fill=Fill), size=3, pch = 21) +

  scale_fill_manual(values = margin_color, name="")+ #add legend for marginality point
  
  facet_wrap(~Species, nrow=3) + #breaking plots up by species
  
  labs(x='Marginality', y='Specialization') + #adding axis labels
  
  theme_bw(20) + # set 'font size' to 20
  theme(panel.grid.major = element_blank(), #remove major grid lines
        panel.grid.minor = element_blank(), #remove minor grid lines
        #axis.title=element_text(size=18)   #set axes titles at specific size 
        strip.text.x = element_text(size = 18)) #set plot subtitles at specific size


# Save Plot ---------------------------------------------------------------


png('Plots/NicheSpaceBiplot.png', width = 1500, height=2000, res=150)
  bp
dev.off()



# Old code ----------------------------------------------------------------
# 
# acronyms <- c('Marfla', 'Callat', 'Urobel')
# species_names <- c('Yellow-bellied Marmot', 'Golden Mantled Ground Squirrel',
#                    "Belding's Ground Squirrel")
# 

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
