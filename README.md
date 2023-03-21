# ENFA_Plots
Code for creating publication quality plots of Ecological Niche Factor Analysis models

The code from OriginalExample_GMGS.R was provided to a colleague of mine to use as an example for plotting ENFA models. However, the code was in such disarray that they hired me to sort through the code and determine what was actually necessary to create the relevant plots. I sorted through the code, extracted the relevant information, and created the plots necessary for publication of the paper (reference below).

"Niches of three sympatric montane ground-dwelling squirrels: Relative importance of climate, topography, and landcover" Aviva Rossi; Robert Klinger; Elise Hellwig; Dirk Van Vuren
Ecology and Evolution (accepted)

## Required Packages
adehabitatHS, ggordiplots, data.table, magrittr, ggplot2, vegan, ggnewscale (Biplot only)

# Scripts

## 1_Figure_Data.R
This script takes 'enfa' class objects created through previous analysis and extracts the relevant information for plotting. 

### Inputs
  * 'enfa' model files
      * Urobel_ENFA_model_output.RDS
      * Marfla_ENFA_model_output.RDS
      * Callat_ENFA_model_output.RDS
  * VariableKey.csv - links variable names and their number codes
  * NudgeLabelPositions.csv - how much each variable label should be moved off center
  
### Outputs
  * Enfa_Scores_fig2.csv (scores for histogram)
  * Hulls_fig3.csv (outlines for biplot)
  * Vectors_fig3.csv (arrows for biplot)
  * MarginPts_fig3.csv (marginality point for biplot)

## 2_Fig2_Histogram.R
This script plots histograms of the ENFA scores comparing those of the 'available' habitat to the 'used' habitat.

### Inputs
  * Enfa_Scores_fig2.csv

### Output
![Figure 2 - Niche Space Histogram](https://user-images.githubusercontent.com/7917918/226501567-1a17ff4a-a73c-42ea-89dd-d635ccddbd98.png)

## 3_Fig3_Biplot.R
This script creates the biplot figure, which combines a plot of the available and used niche space, as well as shows the relative contributions of different environmental variables to the description of the used niche space.

### Inputs
  * Hulls_fig3.csv (outlines for biplot)
  * Vectors_fig3.csv (arrows for biplot)
  * MarginPts_fig3.csv (marginality point for biplot)

### Output
![Figure 3 - Niche Space Biplot](https://user-images.githubusercontent.com/7917918/226502612-74c3efab-ded4-42ca-b81b-5e335187cd5b.png)

## 4_Fig3_Biplot_Alt.R
This script creates an alternate version of the biplot using base R instead of ggplot. This script is much closer to the code originally provided. However, we ended up deciding not to use this version of the plot because it didn't look as professional, and it was much harder to modify.

### Inputs
  * Hulls_fig3.csv (outlines for biplot)
  * Vectors_fig3.csv (arrows for biplot)
  * MarginPts_fig3.csv (marginality point for biplot)

### Output
![Figure 3 - Niche Space Biplot (alternate)](https://user-images.githubusercontent.com/7917918/226502918-5cb54ab7-bd45-43e4-a5f4-9225803e4aad.png)

