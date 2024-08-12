# Code Directory

## Overview

This directory contains the R scripts used for extracting placental pathology features related to chronic chorioamnionitis from the cross-sectional database as part of a grant proposal. 

## Analysis Details

The scripts determine the chorioamnionitis status of participants based on placenta features present in the input dataset and those extracted from a cross-sectional placenta pathology database. A comparison of the results from both data sources revealed inconsistencies for 3 participants. For the final results, the determination based on the features extracted from the placenta pathology database was used.

## Scripts

- **get_placenta_pathology.R**: This script performs the analysis of chronic chorioamnionitis status, including loading data, processing pathology features, and calculating the `ChronicChorioamnionitis` metric based on specified criteria.

## Inputs

- **Participant Data**: A dataset containing the participants for whom chronic chorioamnionitis status is to be determined.
- **Cross-Sectional Database**: A database containing placenta pathology features for all participants.

## Output

- The original input data with additional columns for features consistent with chronic chorioamnionitis and an indicator of chronic chorioamnionitis.


