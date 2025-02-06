################################################################################
## Title: Baseline Table Initialization
## Author: Jack Pohlmann, Yili Du
## Creation Date: May 31st, 2024
## Updated Date: Feb 5th, 2025
################################################################################

## ----------------------------
## Add stroke side information
## ----------------------------
# Filter rows with non-missing 'mca_stroke_side', select relevant columns,
# rename the variable, and keep unique rows.
strokeside <- redcap %>% 
  drop_na(mca_stroke_side) %>% 
  select(id, mca_stroke_side1 = mca_stroke_side) %>% 
  distinct()

# Merge stroke side information into the 'otv' dataset.
otv <- otv %>% 
  left_join(strokeside, by = 'id')

## ---------------------------------------------------------
## Add hemorrhagic transformation information for each patient
## ---------------------------------------------------------
# Process the 'redcap' data: keep non-missing 'hemorrhage' values, group by id,
# and assign a binary variable 'hemorrhage1' indicating whether any record equals 1.
hem <- redcap %>% 
  drop_na(hemorrhage) %>% 
  select(id, hemorrhage) %>% 
  group_by(id) %>%
  mutate(hemorrhage1 = ifelse(any(hemorrhage == 1), 1, 0)) %>% 
  ungroup() %>% 
  select(id, hemorrhage1) %>% 
  distinct()

# Extract ECASS (European Cooperative Acute Stroke Study) checkbox variables.
hem1 <- redcap %>% 
  select(id, ecass___0, ecass___1, ecass___2, ecass___3, ecass___4) %>% 
  distinct()

# Combine multiple records into one row per patient and create new binary variables.
hem1_cat <- hem1 %>% 
  group_by(id) %>%
  mutate(
    ecass1___0 = ifelse(any(ecass___0 == 1), 1, 0),
    ecass1___1 = ifelse(any(ecass___1 == 1), 1, 0),
    ecass1___2 = ifelse(any(ecass___2 == 1), 1, 0),
    ecass1___3 = ifelse(any(ecass___3 == 1), 1, 0),
    ecass1___4 = ifelse(any(ecass___4 == 1), 1, 0),
    
    # Dichotomous hemorrhagic transformation types (05.31.24)
    ecass2___0 = ifelse(any(ecass___0 == 1 | ecass___1 == 1), 1, 0), # Petechial Only Hemorrhage (HI1 + HI2)
    ecass2___1 = ifelse(any(ecass___2 == 1 | ecass___3 == 1), 1, 0)  # Parenchymal Hemorrhage (PI1 + PI2)
  ) %>%
  select(id, ecass1___0, ecass1___1, ecass1___2, ecass1___3, ecass1___4,
         ecass2___0, ecass2___1) %>%
  distinct() %>% 
  ungroup()

# Merge hemorrhagic transformation information into otv.
otv <- otv %>% 
  left_join(hem, by = 'id') %>%
  left_join(hem1_cat, by = 'id')

rm(hem,hem1,hem1_cat,strokeside)
## ---------------------------
## Factorize and relevel variables
## ---------------------------

# Convert 'race' variable to a factor with meaningful labels and set reference level.
otv$race <- factor(case_when(
  otv$race == 0 ~ "WHITE",
  otv$race == 1 ~ "BLACK",
  otv$race == 2 ~ "ASIAN",
  otv$race == 3 ~ "Native American",
  otv$race == 4 ~ "Unknown or Other",   # unknown
  otv$race == 999 ~ "Unknown or Other",  # other; many may be Hispanic/Latino
  .default = 'Unknown or Other'
), levels = c("WHITE", "BLACK", "ASIAN", "Native American", "Unknown or Other"))
# Set 'WHITE' as the reference level.
otv$race <- relevel(otv$race, ref = "WHITE")

# Convert 'ethn' variable to a factor with labels and set reference.
otv$ethn <- factor(case_when(
  otv$ethn == 0 ~ "Not Hispanic or Latino",
  otv$ethn == 1 ~ "Hispanic or Latino",
  otv$ethn == 2 ~ "Patient Refused or Unknown",  # patient refused
  otv$ethn == 3 ~ "Patient Refused or Unknown",  # unknown
  .default = "Patient Refused or Unknown"
), levels = c("Not Hispanic or Latino", "Hispanic or Latino", "Patient Refused or Unknown"))
otv$ethn <- relevel(otv$ethn, ref = "Not Hispanic or Latino")

# Create a binary TICI (Thrombolysis in Cerebral Infarction) score variable.
# TICI>=2b indicates a successful recanalization.
otv$tici_b <- factor(case_when(
  otv$tici >= 3 ~ "TICI>=2b",
  TRUE ~ "Non TICI >=2b"
), levels = c("TICI>=2b", "Non TICI >=2b"))
otv$tici_b <- relevel(otv$tici_b, ref = "Non TICI >=2b")

# Convert Global Cerebral Atrophy Score 'gca' to a factor with descriptive levels.
otv$gca <- factor(case_when(
  otv$gca == 0 ~ 'Normal Volume/no ventricular enlargement',
  otv$gca == 1 ~ "Opening of sulci/mild ventricular enlargement",
  otv$gca == 2 ~ "Volume loss of gyri/moderate ventricular enlargement", 
  otv$gca == 3 ~ "'Knife-blade' atrophy/severe ventricular enlargement", 
  otv$gca == 999 ~ "Indeterminate"
), levels = c('Normal Volume/no ventricular enlargement',
              "Opening of sulci/mild ventricular enlargement",
              "Volume loss of gyri/moderate ventricular enlargement",
              "'Knife-blade' atrophy/severe ventricular enlargement",
              "Indeterminate"))
otv$gca <- relevel(otv$gca, ref = 'Normal Volume/no ventricular enlargement')

# Convert MCA stroke side to a factor.
otv$mca_stroke_side1 <- factor(case_when(
  otv$mca_stroke_side1 == 0 ~ 'Left',
  otv$mca_stroke_side1 == 1 ~ "Right"
), levels = c('Left', 'Right'))
otv$mca_stroke_side1 <- relevel(otv$mca_stroke_side1, ref = 'Left')

# Create a categorical variable for ASPECTS score.
# If aspects1 is between 8 and 10, assign 3; between 0 and 3, assign 1; else assign 2.
otv$aspects1_cat <- ifelse(otv$aspects1 >= 8 & otv$aspects1 <= 10, 3,
                            ifelse(otv$aspects1 >= 0 & otv$aspects1 <= 3, 1, 2))
# Convert to factor with descriptive labels.
otv$aspects1_cat <- factor(case_when(
  otv$aspects1_cat == 1 ~ '3 - 0',
  otv$aspects1_cat == 2 ~ '7 - 4',
  otv$aspects1_cat == 3 ~ '10 - 8'
), levels = c('10 - 8', '7 - 4', '3 - 0'))
otv$aspects1_cat <- relevel(otv$aspects1_cat, ref = '10 - 8')

# Convert 'sex' variable to factor.
# 0 indicates Female and 1 indicates Male.
otv$sex <- factor(case_when(
  otv$sex == 0 ~ 'Female',
  otv$sex == 1 ~ 'Male'
), levels = c('Female', 'Male'))
otv$sex <- relevel(otv$sex, ref = 'Male')

## ----------------------------------
## Convert selected columns to factors
## ----------------------------------
for (i in c("sex",
            # Past Medical History variables:
            "pmh___0", # Atrial Fibrillation
            "pmh___1", # Hypertension
            "pmh___3", # Prior Stroke
            # Acute Intervention variables:
            "tpa",    # Tissue Plasminogen Activator (tPA)
            "mt",     # Mechanical Thrombectomy
            "tici",
            "mca_stroke_side1",
            # ASPECTS categories and hemorrhage variables:
            "aspects1_cat",
            "hemorrhage1", 
            'ecass1___0',  # HI1 (petechial hemorrhage)
            'ecass1___1',  # HI2 (petechial hemorrhages with mild confluence/no mass effect)
            'ecass1___2',  # PH1 (< =30% of infarcted area; minor mass effect)
            'ecass1___3',  # PH2 (>30% of infarct zone; substantial mass effect)
            'ecass1___4',  # SAH
            'ecass2___0',  # Dichotomized hemorrhage type 1 (HI1 + HI2)
            'ecass2___1',  # Dichotomized hemorrhage type 2 (PI1 + PI2)
            "gca",
            'mls5', 'mls7', 'pgs4', 'surg',
            'ltme', 'ltme2', 'ltme3', 'plme',
            'nd', 'ndce', 'cmo',
            'death',
            'ifosmotic',
            'tici_b'
)){
  otv[[i]] <- as.factor(otv[[i]])
}

## ----------------------------------
## Define columns for the baseline table
## ----------------------------------
xcols <- c(
  # Demographics
  "age",
  "sex",
  "race",
  "ethn",
  
  # Past Medical History
  "pmh___0",  # Atrial Fibrillation
  "pmh___1",  # Hypertension
  "pmh___3",  # Prior Stroke
  
  # Presentation Information
  "mca_stroke_side1", 
  "nihsspres",  # NIH Stroke Scale
  "aspects1",  
  "aspects1_cat",
  
  "hemorrhage1",
  'ecass2___0', 'ecass2___1',
  
  "mingcs",
  "maxmls",
  
  # Acute Intervention
  "tpa",      # Intravenous Thrombolysis (tPA or TNK)
  "mt",       # Mechanical Thrombectomy
  "tici_b",   # Binary TICI score
  
  "ifosmotic", 
  'surg',
  'cmo',      # Comfort Measures Only (including DNR, DNI, etc.)
  'ndce',
  'death'
)

## ----------------------------------
## Generate the baseline table
## ----------------------------------
# Assuming 'combined_tbl' is a custom function that creates the descriptive table.
# 'outcome_strat' defines the stratification outcome variable.
# Replace 'nd' with the appropriate outcome variable if needed.
outcome_strat <- 'nd'
baseline_tbl <- combined_tbl(outcome_strat, 
                             xcols,
                             data = otv)

# Rename columns for clarity.
names(baseline_tbl)[3] <- "Non-Case"
names(baseline_tbl)[4] <- toupper(outcome_strat)

# Format the table to HTML using kableExtra.
baseline_tbl_html <- baseline_tbl %>%
  kbl() %>% 
  kable_paper(bootstrap_options = "striped", full_width = FALSE) %>%
  add_indent(c(4:5, 7:11, 13:15, 20, 21, 25:27, 29:32, 38, 39))

# The final HTML table is stored in 'baseline_tbl_html'
