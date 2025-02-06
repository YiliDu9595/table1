``` markdown
# Table 1 Generation for Pupillometry vs Neurologic Deterioration Analyses

This repository contains the R Markdown file and supporting scripts needed to generate the baseline Table 1 for the "Pupillometry vs Neurologic Deterioration Analyses" project.

## Contents

- **R Markdown File**: `table1_demo.Rmd`  
  Contains the code to import data, load functions, and generate Table 1 in HTML format.
  
- **Helper Script**: `helpers/baseline_table_demo.R`  
  Contains custom code for generating the baseline table.

- **Data Files**:
  - `data/redcap_02-05-2025.csv` — Raw REDCap data.
  - `data/baseline_02-05-2025.csv` — Pre-processed baseline data.

- **External Script**:  
  The repository also sources a remote script from The Ong Lab’s GitHub which contains custom table formatting functions.

## Prerequisites

Before generating the table, ensure you have the following R packages installed:

- `readr` (for reading CSV files)
- `tidyverse` (includes dplyr, tidyr, ggplot2, etc.)
- `kableExtra` (for advanced table formatting functions such as `add_indent`)

You can install these packages by running:

```r
install.packages(c("readr", "tidyverse", "kableExtra"))
```

## How to Generate Table 1

1.  **Set Up the Working Directory**\
    Ensure your working directory is set to the project root (the folder that contains this README, the `data` folder, and the `helpers` folder). In the R Markdown file, the root directory is set using:

    ``` r
    knitr::opts_knit$set(root.dir = "/path/to/your/project/folder")
    ```

    Adjust this path if necessary.

2.  **Run the R Markdown File**\
    Open the `table1_demo.Rmd` file in RStudio. You can render the file to HTML by clicking the "Knit" button or running the following command in the R console:

    ``` r
    rmarkdown::render("table1_demo.Rmd")
    ```

    This will execute the code chunks that:

    -   Import the raw data and baseline data.
    -   Load external and helper functions.
    -   Generate and display Table 1.

3.  **Viewing the Results**\
    The output is an HTML document that contains the generated Table 1. The final table is stored in the variable `baseline_tbl_html` and is printed in the document.

## File Structure

```         
.
├── README.md
├── table1_demo.Rmd             # Main R Markdown file for generating Table 1
├── helpers
│   └── baseline_table_demo.R   # Helper script for generating the table
└── data
    ├── redcap_02-05-2025.csv     # Raw REDCap data file
    └── baseline_02-05-2025.csv   # Baseline data file
```

## Additional Notes

-   The R Markdown file sets global options to suppress warnings and messages, and configures figure dimensions.
-   The table formatting relies on a custom script hosted on The Ong Lab's GitHub. Make sure you have an internet connection so that the remote script can be sourced.
-   If you encounter any issues (e.g., file paths, missing packages), verify that the working directory is correctly set and that all necessary packages are installed.

## Contact

For further questions or issues, please contact Yili Du at yilidu\@bu.edu.

------------------------------------------------------------------------

By following these steps and ensuring the necessary files and packages are in place, you should be able to generate and view Table 1 without any problems. \`\`\`

------------------------------------------------------------------------
