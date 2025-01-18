## Define the function clusterSOM() to perform clustering on the SOM nodes.

#' Perform Clustering on SOM Nodes
#'
#' Groups similar nodes of the SOM using hierarchical clustering and the KGS
#' penalty function to determine the optimal number of clusters.
#'
#' @import RColorBrewer aweSOM dplyr kohonen maptree
#' @param model The trained SOM model object.
#' @param plot_result A logical value indicating whether to plot the clustering result. Default is `TRUE`.
#' @param file_path An optional string specifying the path to a CSV file. If provided, clusters are assigned to the observations in the original dataset, and the updated data with an added "Cluster" column is stored globally as 'Data&Clusters'.
#' @return A plot of the clusters on the SOM grid (if `plot_result = TRUE`). Additionally, if `file_path` is specified, a modified dataset with cluster assignments is stored in the global environment.
#' @examples
#' \dontrun{
#'   clusterSOM(model, plot_result = TRUE)
#'   clusterSOM(model, plot_result = FALSE, file_path = "data.csv")
#' }
#' @export

clusterSOM <- function(model, plot_result = TRUE, file_path = NULL) {

  # Set seed for reproducibility
  set.seed(231122)

  # Calculate distance matrix and perform hierarchical clustering
  distance <- dist(getCodes(model))
  clustering <- hclust(distance)

  # Determine optimal number of clusters using the KGS penalty function
  optimal_k <- kgs(clustering, distance, maxclust = 20)
  clusters <- as.integer(names(optimal_k[which(optimal_k == min(optimal_k))]))

  # Output the calculated number of clusters
  cat(clusters, "clusters were determined.", "\n")

  # Assign clusters to SOM units
  som_cluster <- cutree(clustering, clusters)

  # Define an unlimited color palette using RColorBrewer
  max_colors <- max(20, clusters)  # Ensure there are enough colors for the clusters
  pretty_palette <- colorRampPalette(brewer.pal(8, "Set1"))(max_colors)

  # Plot the result if requested
  if (plot_result) {
    plot(model, type = "mapping", bgcol = pretty_palette[som_cluster], main = "Clusters")
    add.cluster.boundaries(model, som_cluster)
  }

  # If file_path is provided, read the data, assign clusters, and store it globally
  if (!is.null(file_path)) {
    # Get the vector with the cluster value for each original observation
    cluster_assignment <- som_cluster[model$unit.classif]
    # Add the assigned clusters as a column to a copy of the original data
    data <- read.csv(file_path)
    data$Cluster <- cluster_assignment
    data <- data[, c("Cluster", setdiff(names(data), "Cluster"))] # Move 'Cluster' to the first column

    # Store the copy of the original data with the assigned clusters in the global environment
    assign("Data&Clusters", data, envir = .GlobalEnv)

    # Inform the user about the exported file
    cat("The original data, now with assigned clusters, is stored as 'Data&Clusters'. This dataset can be exported using the following function:\n")
    cat("write.csv(Data&Clusters, file='C:\\File_path\\...\\New_file_name.csv', row.names=FALSE)\n")
  }
}
