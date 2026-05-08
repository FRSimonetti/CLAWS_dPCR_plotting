#============================
# CLAWS dPCR plotting script
#============================

# This script subsamples double-negative partitions and generates a
# 2D dPCR plot.Subsampling helps with image memory size and handling
# with image softwares

# Prepare an excel table using the raw data from the Qiacuity instrument
# using the # XXXXX csv file. 

# Before proceeding, you will need to do the following:
# 1) Filter out partitions with quality issues --> under the column "invalid",
#    remove values different than 0
# 2) Merge in the same table the ATG and MSD data
# 3) Add a column (k in th example) to indicate double negative partitions
#    (double negative = 0)
# 4) Save the final table as a .csv file

# Minimum required input columns:
#   - atg
#   - msd
#   - double_neg
#
# Dependencies:
#   - tidyplots
#   - readxl
#   - writexl
#   - dplyr
#   - ggplot2

# Load packages ------------------------------------------------------------

library(tidyplots)
library(writexl)
library(dplyr)
library(ggplot2)


# User-defined settings ----------------------------------------------------

input_file  <- "claws_example_data.csv"
output_file <- "subsampled_example.csv"

sheet_name <- 1

n_double_negative <- 500
random_seed <- 123

#these are example thresholds, but you can change them based on your needs.
msd_threshold <- 27
atg_threshold <- 40
#the same applies to axis range

plot_title <- "claws_example"


# Import data --------------------------------------------------------------

raw_data <- read.csv(input_file)

required_columns <- c("atg", "msd", "double_neg")

missing_columns <- setdiff(required_columns, names(raw_data))

if (length(missing_columns) > 0) {
  stop(
    "The input file is missing the following required columns: ",
    paste(missing_columns, collapse = ", ")
  )
}


# Subsample double-negative partitions -------------------------------------

neg_rows <- raw_data |>
  filter(double_neg == 0)

pos_rows <- raw_data |>
  filter(double_neg != 0)

set.seed(random_seed)

n_to_sample <- min(n_double_negative, nrow(neg_rows))

neg_sample <- neg_rows |>
  slice_sample(n = n_to_sample)

plot_data <- bind_rows(neg_sample, pos_rows)


# Save subsampled data -----------------------------------------------------

write.csv(plot_data, output_file, row.names = FALSE)

# Generate dPCR plot -------------------------------------------------------

plot_data |>
  tidyplot(x = atg, y = msd) |>
  add_reference_lines(x = atg_threshold, y = msd_threshold) |>
  add_data_points(
    data = filter_rows(msd < msd_threshold, atg < atg_threshold),
    color = "gray",
    size = 3,
    alpha = 0.5
  ) |>
  add_data_points(
    data = filter_rows(msd > msd_threshold, atg < atg_threshold),
    color = "#56B4E9",
    size = 3,
    alpha = 0.5
  ) |>
  add_data_points(
    data = filter_rows(atg > atg_threshold, msd < msd_threshold),
    color = "#AADC32FF",
    size = 3,
    alpha = 0.5
  ) |>
  add_data_points(
    data = filter_rows(atg > atg_threshold, msd > msd_threshold),
    color = "#482374FF",
    size = 3,
    alpha = 0.5
  ) |>
  adjust_y_axis(limits = c(0, 80)) |>
  adjust_x_axis(limits = c(10, 120)) |>
  add_title(plot_title) |>
  adjust_font(fontsize = 14) |>
  add(
    theme(
      panel.border = element_rect(
        linewidth = 0.25,
        colour = "black",
        fill = NA
      )
    )
  ) |>
  adjust_size(width = 75, height = 75)


# Reproducibility information ---------------------------------------------

sessionInfo()