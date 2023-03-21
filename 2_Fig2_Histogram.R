
# Setup -------------------------------------------------------------------

library(data.table)
library(ggplot2)

#Defines what colors the insides of the histogram bars will be
fills = c('Available'='white', 'Used'='grey10')

#species plot order 
species_names <- c("Belding's Ground Squirrel", 'Yellow-bellied Marmot', 
                   'Golden Mantled Ground Squirrel')

bin_num = 25

# Read In Data ------------------------------------------------------------

#ENFA scores, generated in 1_Figure_Data.R
scores <- fread('data/Enfa_Scores_fig2.csv')
scores$Species <- factor(scores$Species, levels=species_names)

# Create Plot -------------------------------------------------------------

#this plot is a little weird because we actually end of plotting the 'Available'
#data twice. This is a work around because Elise couldn't figure out how to set 
#the color (outline color) of only one group to transparent. For some reason
#transparency or 'alpha' only affects the fill, not the outline. ¯\_('_')_/¯
#The solution was to plot 'Available' with black outlines and no fill, and then
#plot both 'Available' and 'Used' with fill and no outlines. 'Used' was plotted
#with dark grey, and then the transparency was turned up so that it looked 
#regular grey, and the white that was used to plot the available didn't obscure
#the black outlines too much.

p <- ggplot(data=scores) + #set data source
  #plot Available data with black outlines and no fill
  geom_histogram(data=scores[AU=='Available'], 
                 aes(x=value, y=after_stat(density)), color='black', fill=NA, 
                 bins=bin_num) +
  #plot both Available and Used data with fill but no outliens
  geom_histogram(aes(x=value, y=after_stat(density), group=AU, color=AU, fill=AU), 
                 position='identity', alpha=0.3, color=NA, bins=bin_num) +
  
  scale_fill_manual(values=fills, name='Niche Space') + #add legend
  
  #create separate graphs by species and type (marginality vs specialization)
  #and allow y axis to vary between plots, specify number of columns = 2 
  facet_wrap(Species~facetvar, ncol=2, scales='free') + 
  
  labs(x='ENFA Scores', y='Density') + #set axes labels
  theme_bw(22) + #set font to size '22'
  theme(panel.grid.major = element_blank(), #remove major grid lines
        panel.grid.minor = element_blank(), #remove minor grid lines
        strip.text.x = element_text(size = 18)) #set plot titles to be a bit larger


#Manually add in a black box around the white background of the Available 
#Nice Space legend entry after image creation
png('Plots/NicheSpaceHistogram.png', width = 2000, height=2000, res=150)
  p
dev.off()

