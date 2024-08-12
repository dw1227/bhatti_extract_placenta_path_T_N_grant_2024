# Load required libraries
library(tidyverse)  # For data manipulation and visualization
library(readxl)     # For reading Excel files

# Load the main dataset from an RData file
load("data/TDvsPTD_nomising_withMIRFIR.RData")

# Define a helper function to calculate a metric for chronic chorioamnionitis
# This function returns NA if all values are missing, otherwise sums the absolute values
myf0 <- function(x) {
  ifelse(length(x[!is.na(x)]) == 0, NA, sum(abs(x[!is.na(x)])))
}

# Convert 'Main_Index' to character type for consistent matching
ano$Main_Index <- as.character(ano$Main_Index)

# Calculate initial chronic chorioamnionitis status using specified columns
# The status is 1 if the sum of specified columns is >= 1, otherwise 0
ano$ChronicChorioamnionitis_old <- ifelse(
  apply(ano[, c("G1_ST11x", "G2_ST12x", "G3_ST21x", "G4_ST22x", "G5_CPIx")], 1, myf0) >= 1, 
  1, 
  0
)

# Load the cross-sectional data from an Excel file
pdata <- read_xlsx("data/Cross-sectional.xlsx")

# Process pdata:
# - Convert 'EN_Main_Index' to character for matching
# - Filter rows to keep only those matching 'ano$Main_Index'
# - Select relevant columns for analysis
pdata <- pdata %>%
  mutate(EN_Main_Index = as.character(EN_Main_Index)) %>%
  filter(EN_Main_Index %in% ano$Main_Index) %>%
  select("EN_Main_Index", "PH_G1_ST11", "PH_G2_ST12", "PH_G3_ST21", "PH_G4_ST22", "PH_G5_CPI")

# Calculate chronic chorioamnionitis status for pdata using similar logic
pdata$ChronicChorioamnionitis <- ifelse(
  apply(pdata[, c("PH_G1_ST11", "PH_G2_ST12", "PH_G3_ST21", "PH_G4_ST22", "PH_G5_CPI")], 1, myf0) >= 1, 
  1, 
  0
)

# Join 'pdata' with 'ano' on matching indices
# This adds 'ChronicChorioamnionitis' from 'pdata' to 'ano'
ano <- ano %>%
  left_join(pdata, join_by(Main_Index == EN_Main_Index))

# Create a contingency table comparing old and new chorioamnionitis statuses
table(ano$ChronicChorioamnionitis_old, ano$ChronicChorioamnionitis)

# Save the updated 'ano' data frame to an RData file for further use
save(ano, file = "results/TDvsPTD_nomising_withMIRFIR_withcca.RData")

# (Optional) Filtering examples for debugging/validation:
# Check specific participants for discrepancies
# ano %>%
#   filter(!duplicated(Main_Index)) %>%
#   select("Main_Index", "G1_ST11x", "G2_ST12x", "G3_ST21x", "G4_ST22x", "G5_CPIx") %>%
#   filter(Main_Index %in% c("21522", "24749", "25915"))
#   
# pdata %>%
#   filter(!duplicated(EN_Main_Index)) %>%
#   select("EN_Main_Index", "PH_G1_ST11", "PH_G2_ST12", "PH_G3_ST21", "PH_G4_ST22", "PH_G5_CPI") %>%
#   filter(EN_Main_Index %in% c("21522", "24749", "25915"))
