# 01_Descriptives.R
# Descriptive analyses for case numbers, percentages and Table 1 components.

source("00_setup.R")

# Import aggregated CRN/StatsBank data used for descriptive summaries.
df_region <- read_xlsx(file.path(data_dir, "by_region.xlsx"))
df_stage  <- read_xlsx(file.path(data_dir, "by_stage.xlsx"))
df_age    <- read_xlsx(file.path(data_dir, "both_sexes10.xlsx"))
df_site   <- read_xlsx(file.path(data_dir, "df_site_1994.xlsx"))
df_type   <- read_xlsx(file.path(data_dir, "df_type_1984.xlsx"))

# Region codes were recoded to the four health regions used in the manuscript.
df_region <- df_region %>%
  mutate(
    region = recode(as.character(region),
                    "7901" = "South-Eastern Norway",
                    "7902" = "Western Norway",
                    "7903" = "Central Norway",
                    "7904" = "Northern Norway",
                    "0"    = "Norway")
  )

# Total regional case counts in the first and final study year.
region_cases_1980 <- df_region %>%
  filter(year == 1980) %>%
  group_by(region) %>%
  summarise(cases_1980 = sum(Cases, na.rm = TRUE), .groups = "drop")

region_cases_2024 <- df_region %>%
  filter(year == 2024) %>%
  group_by(region) %>%
  summarise(cases_2024 = sum(Cases, na.rm = TRUE), .groups = "drop")

region_cases_total <- df_region %>%
  group_by(region) %>%
  summarise(cases_total = sum(Cases, na.rm = TRUE), .groups = "drop")

region_increase <- df_region %>%
  filter(year %in% c(1980, 2024)) %>%
  group_by(year, region) %>%
  summarise(total_cases = sum(Cases, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = year, values_from = total_cases) %>%
  mutate(increase_percent = ((`2024` / `1980`) - 1) * 100)

# Stage was explored descriptively but due to incompleteness
# of the data, not included as a main analysis in the manuscript.
df_stage <- df_stage %>%
  mutate(stage = recode(as.character(stage),
                        "All stages" = "All stages",
                        "Localized"  = "Localized",
                        "Regional"   = "Regional",
                        "Distant"    = "Distant",
                        "Unknown"    = "Unknown"))

stage_cases_total <- df_stage %>%
  group_by(stage) %>%
  summarise(cases_total = sum(Case, na.rm = TRUE), .groups = "drop")

# Site and subtype analyses used CRN data from the coding periods available for these variables.
site_summary <- df_site %>%
  mutate(Cases_num = as.numeric(Cases)) %>%
  group_by(Gender, Site) %>%
  summarise(
    cases_visible = sum(Cases_num, na.rm = TRUE),
    n_suppressed = sum(is.na(Cases)),
    .groups = "drop"
  ) %>%
  group_by(Gender) %>%
  mutate(percent_visible = cases_visible / sum(cases_visible) * 100) %>%
  ungroup()

type_summary <- df_type %>%
  mutate(Cases_num = as.numeric(Cases)) %>%
  group_by(Gender, Type) %>%
  summarise(
    cases_visible = sum(Cases_num, na.rm = TRUE),
    n_suppressed = sum(is.na(Cases)),
    .groups = "drop"
  ) %>%
  group_by(Gender) %>%
  mutate(percent_visible = cases_visible / sum(cases_visible) * 100) %>%
  ungroup()

# Export descriptive outputs used when preparing Table 1.
write.xlsx(region_cases_total, file.path(table_dir, "region_cases_total.xlsx"), overwrite = TRUE)
write.xlsx(region_increase, file.path(table_dir, "region_increase_1980_2024.xlsx"), overwrite = TRUE)
write.xlsx(stage_cases_total, file.path(table_dir, "stage_cases_total.xlsx"), overwrite = TRUE)
write.xlsx(site_summary, file.path(table_dir, "site_summary.xlsx"), overwrite = TRUE)
write.xlsx(type_summary, file.path(table_dir, "type_summary.xlsx"), overwrite = TRUE)
