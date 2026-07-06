# 03_Period_Analysis.R
# Age-specific incidence rates by calendar period.

source("00_setup.R")

# Period_Analysis.xlsx contains rates by sex, age group and calendar period.
df <- read_xlsx(file.path(data_dir, "Period_Analysis.xlsx"))

# Reshape period columns to long format for plotting.
df_long <- df %>%
  pivot_longer(
    cols = -c(Gender, Age),
    names_to = "Period",
    values_to = "Rate"
  ) %>%
  mutate(
    Period = factor(Period, levels = unique(Period)),
    Age = factor(Age, levels = age_labels)
  )

plot_period_gender <- function(data, gender_label) {
  data %>%
    filter(Gender == gender_label) %>%
    ggplot(aes(x = Period, y = Rate, fill = Age)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_brewer(palette = "Set2") +
    scale_y_log10(
      breaks = c(1, 3, 5, 10, 15, 20, 30, 40, 60, 80, 100, 160, 200, 250, 300, 340),
      limits = c(0.5, 300)
    ) +
    labs(
      title = paste("Rates by period and age group (", gender_label, ")", sep = ""),
      x = "Calendar period",
      y = "Incidence rate per 100,000 population, log-scale",
      fill = "Age group"
    ) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

plot_male <- plot_period_gender(df_long, "Male")
plot_female <- plot_period_gender(df_long, "Female")

# Save panels used for final Figure 3; legend/text placement was adjusted manually.
ggsave(file.path(figure_dir, "Figure3A_Males_period_rates.tiff"), plot_male,
       width = 107 / 25.4, height = 3.5, dpi = 300, compression = "lzw")
ggsave(file.path(figure_dir, "Figure3B_Females_period_rates.tiff"), plot_female,
       width = 107 / 25.4, height = 3.5, dpi = 300, compression = "lzw")

write.xlsx(df_long, file.path(table_dir, "Figure3_period_data.xlsx"), overwrite = TRUE)
