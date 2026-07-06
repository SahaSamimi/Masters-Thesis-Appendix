# 02_Cohort_Analysis.R
# Birth-cohort plots using age-specific incidence rates.

source("00_setup.R")

# APC.xlsx contains annual incidence rates by sex and 10-year age group.
apc_data <- read_xlsx(file.path(data_dir, "APC.xlsx"))

# Convert age-group columns to long format and approximate year of birth.
df_long <- apc_data %>%
  pivot_longer(
    cols = all_of(age_labels),
    names_to = "AgeGroup",
    values_to = "Rate"
  ) %>%
  mutate(
    AgeMid = age_midpoints[AgeGroup],
    Cohort = Year - AgeMid,
    AgeGroup = factor(AgeGroup, levels = age_labels)
  )

plot_apc_gender <- function(data, gender_label) {
  data_gender <- data %>% filter(Gender == gender_label)

  label_data <- data_gender %>%
    group_by(AgeGroup) %>%
    filter(Cohort == max(Cohort, na.rm = TRUE)) %>%
    slice_tail(n = 1) %>%
    ungroup()

  ggplot(data_gender, aes(x = Cohort, y = Rate, group = AgeGroup)) +
    geom_line(color = "grey40", alpha = 0.5) +
    geom_smooth(se = FALSE, color = "black", span = 0.5) +
    geom_text(data = label_data, aes(label = AgeGroup),
              hjust = -0.1, vjust = 0, size = 4, color = "black") +
    scale_y_log10(
      breaks = c(1, 2, 3, 4, 5, 7, 10, 20, 30, 50, 100, 150, 200, 340),
      limits = c(0.5, 300)
    ) +
    expand_limits(x = max(data_gender$Cohort, na.rm = TRUE) + 5) +
    labs(
      x = "Year of birth",
      y = "Incidence rate per 100,000 population, log-scale",
      title = gender_label
    ) +
    theme_minimal(base_size = 12) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_line(color = "grey85"),
      panel.grid.major.y = element_line(color = "grey90")
    )
}

plot_male <- plot_apc_gender(df_long, "Male")
plot_female <- plot_apc_gender(df_long, "Female")

# Save the two panels used for final Figure 1; final combined layout was adjusted manually.
ggsave(file.path(figure_dir, "Figure1A_Males_birth_cohort.tiff"), plot_male,
       width = 107 / 25.4, height = 3.5, dpi = 300, compression = "lzw")
ggsave(file.path(figure_dir, "Figure1B_Females_birth_cohort.tiff"), plot_female,
       width = 107 / 25.4, height = 3.5, dpi = 300, compression = "lzw")

write.xlsx(df_long, file.path(table_dir, "Figure1_cohort_data.xlsx"), overwrite = TRUE)
