# Table 1 Generation for Pupillometry vs Neurologic Deterioration Analyses

This repository contains the R Markdown file and supporting scripts needed to generate the baseline Table 1 for the "Pupillometry vs Neurologic Deterioration Analyses" project.

## Contents

-   **R Markdown File**: `table1_demo.Rmd`\
    Contains the code to import data, load functions, and generate Table 1 in HTML format.

-   **Helper Script**: `helpers/baseline_table_demo.R`\
    Contains custom code for generating the baseline table.

-   **Data Files**:

    -   `data/redcap_02-05-2025.csv` — Raw REDCap data.
    -   `data/baseline_02-05-2025.csv` — Pre-processed baseline data.

-   **External Script**:\
    The repository also sources a remote script from The Ong Lab’s GitHub which contains custom table formatting functions.

## Prerequisites

Before generating the table, ensure you have the following R packages installed:

-   `readr` (for reading CSV files)
-   `tidyverse` (includes dplyr, tidyr, ggplot2, etc.)
-   `kableExtra` (for advanced table formatting functions such as `add_indent`)
