
# CLAWS dPCR plotting script

[![DOI](https://zenodo.org/badge/123456789.svg)](https://doi.org/10.5281/zenodo.1234567)

This repository contains a simple R workflow used to visualize raw
digital PCR (dPCR) partition data for the CLAWS assay.

The script was developed to support analyses presented in:

> Box et al.\
> *5′ Leader Defects 1 Drive Persistent HIV-1 Viremia on Long-Term ART,
> Nature Communications, 2026*

The workflow: - imports raw dPCR partition data, from the Qiacuity
instrument but it can be adapted for any dPCR system with RFU values of
each partition - subsamples double-negative partitions for visualization
clarity and to generate lightr images for publication - generates
publication-style 2D fluorescence plots using the `tidyplots` package.

------------------------------------------------------------------------

# Repository contents

``` text
CLAWS_dPCR_plotting.R      Main plotting script
claws_example_data.csv     Example input dataset
subsampled_example.csv          Example output dataset
LICENSE                    MIT license
README.md                  Documentation
```

------------------------------------------------------------------------

# Requirements

## R version

Tested with:

``` r
R >= 4.3
```

## Required packages

``` r
install.packages(c(
  "tidyplots",
  "dplyr",
  "ggplot2"
))
```

------------------------------------------------------------------------

# Input data format

The input `.csv` file should contain, at a minimum, the following
columns:

| Column       | Description                              |
|--------------|------------------------------------------|
| `atg`        | Fluorescence intensity for ATG probe     |
| `msd`        | Fluorescence intensity for MSD probe     |
| `double_neg` | Indicator for double-negative partitions |

Example:

| atg  | msd  | double_neg |
|------|------|------------|
| 12.3 | 8.1  | 0          |
| 55.7 | 34.2 | 1          |

------------------------------------------------------------------------

# Usage

Place the input `.csv` file in the working directory and run:

``` r
source("CLAWS_dPCR_plotting.R")
```

The script will: 1. import the data, 2. subsample double-negative
partitions, 3. save the subsampled dataset, 4. generate a dPCR scatter
plot.

------------------------------------------------------------------------

# Output

The workflow generates: - a subsampled `.csv` dataset, - a
publication-style dPCR partition plot.

------------------------------------------------------------------------

# Notes

This software is purely for visualization purposes, use the original
instrument's software to set thresholds and determine positive
partitions

Double-negative partitions are randomly subsampled to improve plot
readability while preserving all positive partitions.

Random subsampling is reproducible through a fixed random seed.

This function can be skipped if one wants to preserve all partitions.

------------------------------------------------------------------------

# Dependencies

This workflow uses the `tidyplots` R package:

> Engler JB. tidyplots empowers life scientists with easy code-based
> data visualization. iMeta. 2025. <https://doi.org/10.1002/imt2.70018>.

tidyplots repository: <https://github.com/jbengler/tidyplots>

------------------------------------------------------------------------

# License

This repository is distributed under the MIT License.

------------------------------------------------------------------------

# Author

Francesco R. Simonetti\
Johns Hopkins University\
Division of Infectious Diseases
