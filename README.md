# somhca
## *R package for Self-Organising Maps coupled with Hierarchical Cluster Analysis (SOM-HCA)*


## Overview
This R package helps perform SOM-HCA analysis on a given dataset.
The package includes functions to estimate the optimal SOM grid size based on various quality measures and subsequently generates a SOM model with the selected dimensions.
It also performs hierarchical clustering on the SOM nodes to group similar units.

## Instructions
### 1. Load the somhca package
Make sure to install and load the somhca package before running the analysis:  
install.packages("somhca")  
library(somhca)

### 2. Read the data
Read the data from an in-memory data frame or matrix, or provide the path and file name of a dataset in CSV format:  
loadMatrix()

### 3. Estimate optimal SOM grid size
Estimate the optimal SOM grid size based on specified criteria:  
optimalSOM()

### 4. Train the final SOM model
Train the SOM model with the selected optimal grid size:  
finalSOM()

### 5. Generate plots
Create various plots to visualize SOM training progress and results:  
generatePlot()

### 6. Perform clustering on SOM nodes
Utilize hierarchical clustering and KGS penalty function to group similar nodes of the SOM:  
clusterSOM()

### 7. Assign clusters to original observations
Add the assigned clusters as a column to a copy of the original data and export the results:  
getClusterData()
