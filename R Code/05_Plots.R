# 05_Plots.R
# Main AAPC plots from Joinpoint exports.
# Annual fitted rate curves shown in the appendix were produced in Joinpoint software.

source("00_setup.R")

# Joinpoint AAPC files exported from the NCI Joinpoint software.
JP_Export_AAPC <- read_delim(file.path(data_dir, "JP_Export_AAPC.csv"),
                             delim = ";", escape_double = FALSE, trim_ws = TRUE)

# Common column names used in the Joinpoint exports.
data <- JP_Export_AAPC %>%
  rename(
    age = `Age group (years)`,
    CI_low = `AAPC C.I. Low`,
    CI_high = `AAPC C.I. High`
  ) %>%
  mutate(
    age = factor(age, levels = 0:6, labels = age_labels),
    sex = recode(as.character(sex), "m" = "Males", "f" = "Females",
                 "male" = "Males", "female" = "Females")
  )

# AAPC over the full study period by sex and age group.
# This was used as a supplementary check, not as the final annual-rate curve figure.
figure_s2 <- ggplot(data, aes(x = age, y = AAPC, fill = sex)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = CI_low, ymax = CI_high, group = sex),
                width = 0.1, color = "grey29",
                position = position_dodge(width = 0.8)) +
  geom_hline(yintercept = 0, color = "grey", linewidth = 0.5) +
  labs(
    x = "Age group (years)",
    y = "AAPC (%)",
    fill = "Sex"
  ) +
  scale_y_continuous(breaks = seq(-10, 10, by = 1), limits = c(-7, 9)) +
  scale_fill_manual(values = c("Males" = "paleturquoise3", "Females" = "peachpuff3")) +
  theme_minimal() +
  theme(
    axis.text = element_text(size = 9),
    axis.title = element_text(size = 10),
    legend.position = "bottom"
  )

ggsave(file.path(figure_dir, "Supplementary_AAPC_by_age_and_sex.tiff"), figure_s2,
       width = 107 / 25.4, height = 3.5, dpi = 300, compression = "lzw")

# Period-specific AAPC values for Figure 2.
data_1980 <- read_delim(file.path(data_dir, "JP_AAPC_1980_2005.csv"),
                        delim = ";", escape_double = FALSE, trim_ws = TRUE) %>%
  rename(age = `Age group (years)`, CI_low = `AAPC C.I. Low`, CI_high = `AAPC C.I. High`) %>%
  mutate(age = factor(age, levels = 0:6, labels = age_labels),
         sex = recode(as.character(sex), "m" = "Males", "f" = "Females"))

data_2006 <- read_delim(file.path(data_dir, "JP_AAPC_2006_2024.csv"),
                        delim = ";", escape_double = FALSE, trim_ws = TRUE) %>%
  rename(age = `Age group (years)`, CI_low = `AAPC C.I. Low`, CI_high = `AAPC C.I. High`) %>%
  mutate(age = factor(age, levels = 0:6, labels = age_labels),
         sex = recode(as.character(sex), "m" = "Males", "f" = "Females"))

plot_1980 <- ggplot(data_1980, aes(x = age, y = AAPC, fill = sex)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = CI_low, ymax = CI_high, group = sex),
                width = 0.1, color = "grey29",
                position = position_dodge(width = 0.8)) +
  geom_hline(yintercept = 0, color = "grey", linewidth = 0.5) +
  labs(x = "Age group (years)", y = "AAPC (%)", fill = "Sex") +
  scale_y_continuous(breaks = seq(-10, 10, by = 1), limits = c(-7, 9)) +
  scale_fill_manual(values = c("Males" = "paleturquoise3", "Females" = "peachpuff3")) +
  theme_minimal() +
  theme(axis.text = element_text(size = 8), axis.title = element_text(size = 8),
        legend.position = "bottom")

plot_2006 <- ggplot(data_2006, aes(x = age, y = AAPC, fill = sex)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +
  geom_errorbar(aes(ymin = CI_low, ymax = CI_high, group = sex),
                width = 0.1, color = "grey29",
                position = position_dodge(width = 0.8)) +
  geom_hline(yintercept = 0, color = "grey", linewidth = 0.5) +
  labs(x = "Age group (years)", y = "AAPC (%)", fill = "Sex") +
  scale_y_continuous(breaks = seq(-10, 10, by = 1), limits = c(-7, 9)) +
  scale_fill_manual(values = c("Males" = "paleturquoise3", "Females" = "peachpuff3")) +
  theme_minimal() +
  theme(axis.text = element_text(size = 8), axis.title = element_text(size = 8),
        legend.position = "bottom")

combined_plot <- plot_1980 + plot_2006 +
  plot_annotation(tag_levels = "A") &
  theme(plot.tag.position = c(0.01, 0.01),
        plot.tag = element_text(size = 10, face = "bold"))

# Save patchwork plot using tiff() to keep LZW compression.
tiff(file.path(figure_dir, "Figure2_AAPC_1980_2005_2006_2024.tiff"),
     width = 107 / 25.4, height = 3, units = "in", res = 300, compression = "lzw")
print(combined_plot)
dev.off()


# Note: after export, figure panel labels, legends and spacing were adjusted manually
# in the manuscript document to match the final thesis layout.
