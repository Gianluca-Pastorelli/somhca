## Define the function readMatrix() to read the data.

#' Read a CSV File and Convert to a Matrix
#'
#' Reads data from a CSV file, optionally removes row headings, and applies
#' specified normalization methods before converting the data to a matrix. In
#' the original dataset, rows represent observations (e.g., samples), columns
#' represent variables (e.g., features), and all cells (except for column
#' headers and, in case, row headers) only contain numeric values.
#'
#' @import RColorBrewer aweSOM dplyr kohonen maptree
#' @param file_path A string specifying the path to the CSV file.
#' @param remove_row_headings A logical value. If `TRUE`, removes the first column of the dataset. This is useful when the first column contains non-numeric identifiers (e.g., sample names) that should be excluded from the analysis. Default is `FALSE`.
#' @param scaling A string specifying the scaling method. Options are:
#'   \describe{
#'     \item{"no"}{No scaling is applied (default).}
#'     \item{"SimpleFeature"}{Each column is divided by its maximum value.}
#'     \item{"MinMax"}{Each column is scaled to range [0, 1].}
#'     \item{"ZScore"}{Each column is Z-score standardized.}
#'   }
#' @return A matrix with the processed data.
#' @examples
#' \dontrun{
#'   myMatrix <- readMatrix("data.csv", TRUE, "MinMax")
#' }
#' @export

readMatrix <- function(file_path, remove_row_headings = F, scaling = "no") {

  # Read the data from the file
  data <- read.csv(file_path)

  # Remove the first column if specified
  if (remove_row_headings) {
    data <- data[, -1]
  }

  # Perform data scaling if specified
  if (scaling == "SimpleFeature") {
    data <- apply(data, 2, function(x) (x/(max(x))))
  } else if (scaling == "MinMax") {
    data <- apply(data, 2, function(x) (x - min(x)) / (max(x) - min(x)))
  } else if (scaling == "ZScore") {
    data <- apply(data, 2, scale)
  }

  # Convert the data to a matrix
  data_matrix <- as.matrix(data)

  return(data_matrix)
}
