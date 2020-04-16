# clean species bc data
library(readr)
library(dplyr)
library(sf)
library(mapview)
library(stringr)
library(rmapshaper)
library(ggplot2)
library(tidyverse)
library(magrittr)

####species data####

species_bc <- readr::read_tsv(file = "/Users/Virginia/Documents/lectures/Undergrad thesis/R documents/BCspeciesdata/data/bcsee_export.tsv")

#remove space from columns
names(species_bc) <- gsub(" ", "", names(species_bc))


# conservation status (red/blue list) function
species_bc %<>% mutate(COSEWIC = str_replace(COSEWIC, "\\(", ""),
                     COSEWIC = str_replace(COSEWIC, "\\)", "")) %>% 
  separate(COSEWIC, c("COSEWIC", "Implemented Date"),
                       sep =" ", extra = "merge") %>%
  mutate(`Implemented Date` = lubridate::parse_date_time(`Implemented Date`, "m y"))

# COSEWIC status abbreviations changed - Seb's version, deleted my old attempt

species_bc <- mutate(species_bc,
                     `COSEWIC Status` = case_when(COSEWIC == "E" ~ "Endangered",
                                                  COSEWIC == "XT" ~ "Extirpated",
                                                  COSEWIC == "T" ~ "Threatened",
                                                  COSEWIC == "X" ~ "Extinct",
                                                  COSEWIC == "SC" ~ "Special Concern",
                                                  COSEWIC == "NAR" ~ "Not At Risk",
                                                  COSEWIC == "DD" ~ "Data Deficient",
                                                  COSEWIC == "E/T" ~ "Endangered/Threatened",
                                                  TRUE ~ "No Status"))


# Dropping columns

species_bc %<>% select(-c(ScientificNameSynonyms, EnglishNameSynonyms, GlobalStatusReviewDate,
                          ProvStatusChangeDate, ProvStatusReviewDate, COSEWICComments,
                          ProvincialFRPA, GOERT, MBCA, SARAComments, BreedingBird, MappingStatus,
                          X46, CDCMaps, COSEWIC))

#### ecosection data ####

ecosections <- select(species_bc, ScientificName, Ecosection)

# this gets ecosections for each ScientificName
ecosections <- do.call("rbind", lapply(1:nrow(ecosections), function(x){
  data <- ecosections[x,]
  splits <- strsplit(data$Ecosection, ";")[[1]]
  data <- data.frame(ScientificName = rep(data$ScientificName, length(splits)),
                     Ecosection = splits, stringsAsFactors = FALSE)
}))

# Loading maps used in analysis
ecosection_map <- sf::st_read("/Users/Virginia/Documents/lectures/Undergrad thesis/R documents/BCspeciesdata/data/ERC_ECOSECTIONS_SP")
# ecosection_map2 <- bcmaps::ecosections()
bc_boundary <- bcmaps::bc_bound()

ecosection_simple <- ms_simplify(ecosection_map)

usethis::use_data(ecosections, internal = TRUE, overwrite = TRUE)
usethis::use_data(bc_boundary, internal = TRUE, overwrite = TRUE)
usethis::use_data(ecosection_simple, internal = TRUE, overwrite = TRUE)
usethis::use_data(species_bc, overwrite = TRUE)
