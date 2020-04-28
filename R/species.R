#' conservation_status
#' 
#' Get BCList, COSEWIC Status and Implemented Date of COSEWIC status for a valid species.
#' 
#' @param species A string of the species.
#' @return A data.frame.
#' @export
#' 
#' @examples 
#' conservation_status("Anemone occidentalis - Carex nigricans")
#'  
#' 

conservation_status <- function(species) {
  
  chk::chk_character(species)
  
  if(!species %in% bcspecies::bc_species$ScientificName){
    chk::err("Invalid scientific name. See bcspecies::bc_species for reference")
  }
  
  species_conservation <- bcspecies::bc_species[bcspecies::bc_species$ScientificName == species,]
  species_conservation_columns <- species_conservation[c("BCList", "COSEWIC Status", "Implemented Date")]
  return(species_conservation_columns)
}

#' species_map
#' 
#' Map distribution of species by BC ecosection.
#' 
#' @param species A string of the species.
#' @return A ggplot object.
#' @export
#' 
#' @examples species_map("Anemone occidentalis - Carex nigricans")
#' 
### species distribution of ecosections function 
species_map <- function(species) {
  
  chk::chk_character(species)
  
  if(!species %in% bcspecies::bc_species$ScientificName){
    chk::err("Invalid scientific name. See bcspecies::bc_species for reference")
  }
  
  ecosections <- ecosections
  ecosection_simple <- ecosection_simple
  bc_boundary <- bc_boundary
  
  
  species_ecosections <- ecosections$Ecosection[ecosections$ScientificName == species]
  species_ecosections_spatial <- ecosection_simple[ecosection_simple$ECOSEC_CD %in% species_ecosections,]
  species_present <- ecosection_simple
  species_present$Present <- ifelse(species_present$ECOSEC_CD %in% species_ecosections, TRUE, FALSE)
  gp <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = bc_boundary, size = 0.2) +
    ggplot2::geom_sf(data = species_present, ggplot2::aes_string(fill = "Present"), size = 0.05) +
    ggplot2::scale_fill_manual(values = c("transparent", "red"),
                      name = " ",
                      labels = c("Species Absent", "Species Present")) +
    ggplot2::labs(title = "Species Distribution by Ecosection",
         subtitle = species)
  return(gp)
}