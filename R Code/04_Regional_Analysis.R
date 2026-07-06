# 04_Regional_Analysis.R
# Health-region AAPC analyses and regional maps.

source("00_setup.R")
library(sf)

# Joinpoint AAPC exports for region-specific analyses.
JP_Export_AAPC <- read_delim(file.path(data_dir, "JP_Export_AAPC.csv"),
                             delim = ";", escape_double = FALSE, trim_ws = TRUE)

# GeoJSON file for Norwegian health regions. Downloaded from GeoNorge.
regions_geojson <- file.path(data_dir, "Helsedistrikter.geojson")

regions_base <- st_read(regions_geojson, quiet = TRUE) %>%
  st_transform(4326) %>%
  mutate(region_en = recode(navn,
                            "Helse Sør-Øst" = "South-Eastern Norway",
                            "Helse Vest" = "Western Norway",
                            "Helse Midt-Norge" = "Central Norway",
                            "Helse Nord" = "Northern Norway"))

# Function used for each sex and period.
make_region_map <- function(data, sex_value, period_title, breaks, labels, colours, file_name) {
  aapc_region <- data %>%
    filter(Gender == sex_value, Region != 4, Region != "whole") %>%
    mutate(region_en = recode(as.character(Region),
                              "0" = "Central Norway",
                              "1" = "Northern Norway",
                              "2" = "South-Eastern Norway",
                              "3" = "Western Norway",
                              "central" = "Central Norway",
                              "north" = "Northern Norway",
                              "south-east" = "South-Eastern Norway",
                              "west" = "Western Norway"))

  regions <- regions_base %>%
    left_join(aapc_region %>% select(region_en, AAPC), by = "region_en") %>%
    mutate(AAPC_cat = cut(AAPC, breaks = breaks, labels = labels, right = TRUE))

  p <- ggplot(regions) +
    geom_sf(aes(fill = AAPC_cat)) +
    scale_fill_manual(values = colours, drop = FALSE) +
    theme_minimal() +
    labs(title = period_title, fill = "AAPC (%)")

  ggsave(file.path(figure_dir, file_name), p,
         width = 107 / 25.4, height = 4.2, dpi = 300, compression = "lzw")

  return(p)
}

# The category cut-offs follow the ranges used in the working regional plots.
map_female_1980 <- make_region_map(
  JP_Export_AAPC, "female", "AAPC by health region (Females, 1980-2005)",
  breaks = c(-Inf, 1.499, 1.999, Inf),
  labels = c("0-1.4", "1.5-1.9", "2.0+"),
  colours = c("0-1.4" = "#a64c4c", "1.5-1.9" = "#733d3d", "2.0+" = "#401f1f"),
  file_name = "Appendix_RegionMap_Females_1980_2005.tiff"
)

map_male_1980 <- make_region_map(
  JP_Export_AAPC, "male", "AAPC by health region (Males, 1980-2005)",
  breaks = c(-Inf, 1.999, 2.999, Inf),
  labels = c("0-1.9", "2.0-2.9", "3.0+"),
  colours = c("0-1.9" = "#5f9ea0", "2.0-2.9" = "#008b8b", "3.0+" = "#006666"),
  file_name = "Appendix_RegionMap_Males_1980_2005.tiff"
)

map_female_2006 <- make_region_map(
  JP_Export_AAPC, "f", "AAPC by health region (Females, 2006-2024)",
  breaks = c(-Inf, 2.999, 3.499, Inf),
  labels = c("0-2.9", "3.0-3.4", "3.5+"),
  colours = c("0-2.9" = "#a64c4c", "3.0-3.4" = "#733d3d", "3.5+" = "#401f1f"),
  file_name = "Appendix_RegionMap_Females_2006_2024.tiff"
)

map_male_2006 <- make_region_map(
  JP_Export_AAPC, "m", "AAPC by health region (Males, 2006-2024)",
  breaks = c(-Inf, 2.999, 3.999, Inf),
  labels = c("0-2.9", "3.0-3.9", "4.0+"),
  colours = c("0-2.9" = "#5f9ea0", "3.0-3.9" = "#008b8b", "4.0+" = "#006666"),
  file_name = "Appendix_RegionMap_Males_2006_2024.tiff"
)
