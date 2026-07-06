# 06_Immigration.R
# Contextual immigration summaries used for Supplementary Table S3.

source("00_setup.R")

# Percentages were transcribed from Statistics Norway tables.
# The table shows immigrants and Norwegian-born to immigrant parents by origin,
# region and selected calendar years.
immigration_s3 <- tibble::tribble(
  ~region, ~origin, ~`1980`, ~`1990`, ~`2000`, ~`2010`, ~`2020`, ~`2024`,
  "Oslo and Akershus", "Europe", 60.4, 43.4, 37.8, 37.7, 42.3, 42.8,
  "Oslo and Akershus", "Africa", 5.7, 8.9, 12.7, 14.7, 14.9, 14.9,
  "Oslo and Akershus", "Asia", 24.5, 39.5, 43.7, 42.8, 38.4, 37.7,
  "Oslo and Akershus", "North America", 7.0, 4.2, 2.3, 1.5, 1.3, 1.3,
  "Oslo and Akershus", "Latin America and the Caribbean", 2.1, 3.7, 3.2, 3.1, 3.0, 3.0,
  "Oslo and Akershus", "Oceania", 0.4, 0.4, 0.2, 0.3, 0.3, 0.3,

  "Eastern Norway", "Europe", 71.5, 54.9, 56.5, 51.8, 50.9, 52.8,
  "Eastern Norway", "Africa", 2.1, 4.7, 5.8, 10.3, 13.4, 12.6,
  "Eastern Norway", "Asia", 15.5, 31.5, 32.2, 34.0, 32.6, 31.6,
  "Eastern Norway", "North America", 8.1, 4.5, 2.4, 1.3, 0.9, 0.9,
  "Eastern Norway", "Latin America and the Caribbean", 2.3, 4.1, 2.9, 2.5, 2.0, 2.0,
  "Eastern Norway", "Oceania", 0.5, 0.4, 0.2, 0.2, 0.2, 0.2,

  "Agder and Rogaland", "Europe", 55.7, 51.1, 52.7, 54.2, 51.1, 53.1,
  "Agder and Rogaland", "Africa", 2.2, 4.9, 6.5, 8.7, 12.2, 11.8,
  "Agder and Rogaland", "Asia", 9.7, 23.7, 28.6, 29.7, 31.1, 29.9,
  "Agder and Rogaland", "North America", 29.8, 13.8, 6.7, 2.9, 1.7, 1.5,
  "Agder and Rogaland", "Latin America and the Caribbean", 1.8, 6.0, 5.0, 4.2, 3.6, 3.4,
  "Agder and Rogaland", "Oceania", 0.8, 0.6, 0.5, 0.4, 0.3, 0.3,

  "Western Norway", "Europe", 63.5, 44.7, 49.2, 54.2, 55.0, 58.0,
  "Western Norway", "Africa", 2.7, 5.0, 7.0, 10.1, 13.1, 12.0,
  "Western Norway", "Asia", 14.3, 31.6, 32.2, 28.5, 26.8, 25.1,
  "Western Norway", "North America", 15.3, 7.5, 3.9, 1.8, 1.3, 1.3,
  "Western Norway", "Latin America and the Caribbean", 3.5, 10.9, 7.5, 5.0, 3.6, 3.4,
  "Western Norway", "Oceania", 0.7, 0.4, 0.3, 0.4, 0.3, 0.3,

  "Trøndelag", "Europe", 69.8, 44.5, 52.2, 49.7, 48.2, 52.4,
  "Trøndelag", "Africa", 1.8, 6.7, 7.8, 11.9, 15.3, 13.7,
  "Trøndelag", "Asia", 13.2, 37.1, 32.7, 33.0, 31.7, 29.3,
  "Trøndelag", "North America", 12.2, 5.4, 3.2, 1.8, 1.6, 1.5,
  "Trøndelag", "Latin America and the Caribbean", 2.2, 6.0, 4.0, 3.4, 2.9, 2.9,
  "Trøndelag", "Oceania", 0.8, 0.3, 0.3, 0.3, 0.3, 0.3,

  "Northern Norway", "Europe", 85.5, 64.8, 65.8, 56.7, 53.2, 61.9,
  "Northern Norway", "Africa", 1.6, 5.1, 7.8, 13.7, 16.0, 12.6,
  "Northern Norway", "Asia", 4.7, 23.2, 22.5, 25.8, 27.6, 22.1,
  "Northern Norway", "North America", 7.0, 4.0, 2.1, 1.4, 1.1, 1.1,
  "Northern Norway", "Latin America and the Caribbean", 1.0, 2.7, 1.8, 2.2, 1.9, 2.0,
  "Northern Norway", "Oceania", 0.3, 0.1, 0.1, 0.3, 0.3, 0.2
)

# Long format was used for quick checks and optional plotting.
immigration_long <- immigration_s3 %>%
  pivot_longer(cols = c(`1980`, `1990`, `2000`, `2010`, `2020`, `2024`),
               names_to = "year", values_to = "percent") %>%
  mutate(year = as.integer(year))

# The original working file also used simple pie charts to inspect selected years.
plot_origin_pie <- function(region_name, selected_year = 2024) {
  values <- immigration_long %>%
    filter(region == region_name, year == selected_year) %>%
    pull(percent)

  labels <- paste(
    immigration_long %>% filter(region == region_name, year == selected_year) %>% pull(origin),
    values, "%"
  )

  pie(values, labels = labels, col = rainbow(length(values)),
      main = paste(region_name, selected_year))
}

write.xlsx(immigration_s3,
           file.path(table_dir, "TableS3_immigration_origin_by_region.xlsx"),
           overwrite = TRUE)
write.xlsx(immigration_long,
           file.path(table_dir, "TableS3_immigration_long.xlsx"),
           overwrite = TRUE)
