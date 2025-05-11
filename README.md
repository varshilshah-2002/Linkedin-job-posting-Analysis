# LinkedIn Job Postings Analysis 2024–25

## Abstract
This study examines LinkedIn job postings from 2024 and 2025, performing comprehensive analysis including data cleaning, feature engineering, exploratory data analysis, sentiment analysis, skills extraction, and time-series visualization. The R script is designed to identify the most active industries, prevalent skills, sentiment trends in job descriptions, and posting patterns over time.

## Introduction
LinkedIn, as one of the largest professional networks, provides valuable data for understanding the evolving job market. This project leverages an enhanced R script to process and analyze LinkedIn job postings for insights into hiring demand, skill requirements, and descriptive sentiment. The modular design follows tidyverse best practices and integrates specialized packages for text and interactive analysis.

## Research Questions
- Which industries and roles have the highest posting volumes?
- What are the prevalent sentiment trends in job descriptions?
- Which skills are most frequently sought after across industries?
- How do posting patterns evolve over time throughout 2024–25?

## Data
The analysis uses a CSV file (`linkedin_jobs_2024_25.csv`) containing metadata for each job posting, including:
- `job_title`
- `job_description`
- `company_name`
- `location`
- `posted_date`
Additional fields are derived during feature engineering.

## Methods
1. **Data Cleaning:** Handling missing values, parsing dates, renaming columns, and removing duplicates.  
2. **Feature Engineering:** Extracting country and experience level from text fields.  
3. **Exploratory Analysis:** Visualizing top countries, experience level distributions, and generating a word cloud of job titles.  
4. **Sentiment Analysis:** Computing NRC sentiment scores on job descriptions.  
5. **Skills Extraction:** Pattern matching common technical skills and plotting frequency.  
6. **Interactive Table:** Displaying key columns with DT for dynamic exploration.  
7. **Time-Series Analysis:** Plotting posting counts by date to identify trends.  
8. **Export:** Saving cleaned and enriched dataset to `linkedin_cleaned_2024_25.csv`.

## Results
- Identified top countries and roles with highest posting counts.  
- Revealed emotional tone prevalent in job descriptions through sentiment analysis.  
- Ranked in-demand skills such as Python, SQL, AWS, and Docker.  
- Highlighted temporal patterns, showing seasonal and monthly fluctuations.

## Conclusion
This README and the accompanying R script provide a reproducible workflow for job posting analysis. Future enhancements could include live API integration, advanced predictive modeling, and deployment as an interactive Shiny dashboard.

## How to Run the Analysis
```bash
# Install required R packages
Rscript -e "install.packages(c('tidyverse','lubridate','syuzhet','wordcloud','DT','plotly','hrbrthemes'))"

# Execute the analysis
Rscript linkedin_job_analysis_2024_25.R
```

## Files
- `linkedin_job_analysis_2024_25.R` – Main R script with analysis
- `README.md` – Project overview and instructions  
- `linkedin_jobs_2024_25.csv` – Raw data file  
- `linkedin_cleaned_2024_25.csv` – Cleaned dataset output

