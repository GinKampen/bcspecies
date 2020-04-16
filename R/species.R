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