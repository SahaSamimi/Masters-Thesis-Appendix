# 00_setup.R
# Basic setup for the R-code submitted with the master's thesis.
#
# The original analysis code was more extensive and included exploratory checks,
# repeated plot versions and local path testing. This submitted version is a
# cleaned summary of the main analysis steps used for the manuscript.
# Joinpoint APC/AAPC estimates and annual fitted rate curves were calculated
# in the Joinpoint software. Exported results were imported into R for tables,
# figures and comparison. Final plot layout was adjusted manually for the thesis.

rm(list = ls())

# Use the folder in which this script is saved as the project folder.
# All other paths below are relative to this folder.
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(dplyr)
library(tidyr)
library(readxl)
library(readr)
library(ggplot2)
library(openxlsx)
library(patchwork)
library(RColorBrewer)

# No random methods were used in the analyses, but a seed is set for completeness.
set.seed(42)

data_dir <- "data"
out_dir <- "outputs"
table_dir <- file.path(out_dir, "tables")
figure_dir <- file.path(out_dir, "figures")
session_dir <- file.path(out_dir, "session_info")

dir.create(out_dir, showWarnings = FALSE)
dir.create(table_dir, showWarnings = FALSE)
dir.create(figure_dir, showWarnings = FALSE)
dir.create(session_dir, showWarnings = FALSE)

sink(file.path(session_dir, "sessionInfo.txt"))
cat("R session information for master's thesis analyses\n\n")
print(Sys.Date())
print(sessionInfo())
sink()

# Common labels used across scripts.
age_labels <- c("10-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80+")
age_midpoints <- c("10-29" = 20, "30-39" = 35, "40-49" = 45,
                   "50-59" = 55, "60-69" = 65, "70-79" = 75, "80+" = 85)

region_labels <- c(
  "0" = "Central Norway",
  "1" = "Northern Norway",
  "2" = "South-Eastern Norway",
  "3" = "Western Norway",
  "4" = "Norway"
)
