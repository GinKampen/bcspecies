#' conservation_status
#' @param species the species provided
#' @return A table containing results of BcList, COSWEIC status and Implemented COSWEIC date 
#' @export
#' 
#' @examples 
#' conservation_status("Anemone occidentalis - Carex nigricans")
#'  
#' 

conservation_status <- function(species) {
  species_conservation <- bcspecies::bc_species[bcspecies::bc_species$ScientificName == species,]
  species_conservation_columns <- species_conservation[c("BCList", "COSEWIC Status", "Implemented Date")]
  return(print(species_conservation_columns))
}

#' species_map
#' @param species the species provided
#' @return a map containing highlighted ecosections connected to species provided
#' @export
#' 
#' @examples 
#' 
### species distribution of ecosections function 
species_map <- function(species) {
  ecosections <- bcspecies:::ecosections
  ecosection_simple <- bcspecies:::ecosection_simple
  bc_boundary <- bcspecies:::bc_boundary
  
  
  species_ecosections <- ecosections$Ecosection[ecosections$ScientificName == species]
  species_ecosections_spatial <- ecosection_simple[ecosection_simple$ECOSEC_CD %in% species_ecosections,]
  species_present <- ecosection_simple
  species_present$Present <- dplyr::if_else(species_present$ECOSEC_CD %in% species_ecosections, TRUE, FALSE)
  gp <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = bc_boundary, size = 0.2) +
    ggplot2::geom_sf(data = species_present, ggplot2::aes(fill = Present), size = 0.05) +
    ggplot2::scale_fill_manual(values = c("transparent", "red"),
                      name = " ",
                      labels = c("Species Absent", "Species Present")) +
    ggplot2::labs(title = "Species Distribution by Ecosection",
         subtitle = species)
  return(print(gp))
}