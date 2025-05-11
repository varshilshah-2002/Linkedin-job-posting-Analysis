# LinkedIn Job Postings 2024–25 Analysis
# Author: Varshil Shah
# Date: 11th May 2025
# Description: This script analyzes LinkedIn job postings with in-depth data cleaning, EDA, NLP, and visualization.

# ===============================
# 1. SETUP
# ===============================
# Load required packages
packages <- c("tidyverse", "lubridate", "stringr", "ggplot2", "wordcloud", "tm", "SnowballC",
              "scales", "gridExtra", "syuzhet", "plotly", "reshape2", "DT", "hrbrthemes")

# Install any missing packages
installed_packages <- rownames(installed.packages())
for (pkg in packages) {
  if (!(pkg %in% installed_packages)) install.packages(pkg, dependencies = TRUE)
}

# Load libraries
lapply(packages, library, character.only = TRUE)

# Set global options
options(scipen = 999)

# ===============================
# 2. DATA IMPORT
# ===============================
# Load the CSV (replace with your actual file)
df <- read.csv("linkedin_jobs_2024_25.csv", stringsAsFactors = FALSE)

# Show basic structure
str(df)
summary(df)

# ===============================
# 3. DATA CLEANING
# ===============================
# Convert date column if it exists
if ("posted_date" %in% colnames(df)) {
  df$posted_date <- as.Date(df$posted_date, format = "%Y-%m-%d")
}

# Rename columns for consistency
colnames(df) <- tolower(gsub(" ", "_", colnames(df)))

# Remove duplicates
df <- df[!duplicated(df), ]

# Check NA values
na_summary <- sapply(df, function(x) sum(is.na(x)))
print(na_summary)

# Fill or drop NAs depending on context
df$location[is.na(df$location)] <- "Not Specified"

# ===============================
# 4. FEATURE ENGINEERING
# ===============================
# Extract country from location
df$country <- sapply(strsplit(df$location, ","), function(x) trimws(tail(x, 1)))

# Clean job titles
df$job_title <- str_to_title(df$job_title)

# Create experience level column
df$experience_level <- ifelse(str_detect(df$job_description, "0-1 year|entry level|fresher"), "Entry",
                              ifelse(str_detect(df$job_description, "2-5 years|mid level"), "Mid",
                                     ifelse(str_detect(df$job_description, "6\+ years|senior"), "Senior", "Unspecified")))

# ===============================
# 5. EXPLORATORY DATA ANALYSIS
# ===============================
# Top countries by job postings
country_count <- df %>% count(country, sort = TRUE) %>% head(10)
ggplot(country_count, aes(x = reorder(country, n), y = n, fill = country)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top 10 Countries by Job Postings", x = "Country", y = "Count")

# Experience level distribution
ggplot(df, aes(x = experience_level, fill = experience_level)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Job Postings by Experience Level")

# Job roles word cloud
text_corpus <- Corpus(VectorSource(df$job_title))
text_corpus <- text_corpus %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords("english")) %>%
  tm_map(stripWhitespace)

tdm <- TermDocumentMatrix(text_corpus)
matrix <- as.matrix(tdm)
words <- sort(rowSums(matrix), decreasing = TRUE)
df_words <- data.frame(word = names(words), freq = words)

set.seed(123)
wordcloud(words = df_words$word, freq = df_words$freq, min.freq = 2,
          max.words = 100, random.order = FALSE, colors = brewer.pal(8, "Dark2"))

# ===============================
# 6. SENTIMENT ANALYSIS
# ===============================
# Apply sentiment analysis to job descriptions
job_texts <- tolower(df$job_description)
sentiment_scores <- get_nrc_sentiment(job_texts)

# Combine sentiment with original data
df_sentiments <- cbind(df, sentiment_scores)

# Plot sentiments
sentiment_totals <- colSums(sentiment_scores[, 1:8])
barplot(sentiment_totals, col = rainbow(8), las = 2,
        main = "Overall Sentiment in Job Descriptions", ylab = "Frequency")

# ===============================
# 7. SKILLS EXTRACTION
# ===============================
extract_skills <- function(description) {
  skills <- c("python", "java", "sql", "aws", "excel", "machine learning", "docker", "kubernetes", "linux", "git")
  matches <- skills[sapply(skills, function(skill) grepl(skill, tolower(description)))]
  return(paste(matches, collapse = ", "))
}

df$skills <- sapply(df$job_description, extract_skills)

# Skills frequency
skill_freq <- unlist(strsplit(paste(df$skills, collapse = ","), split = ",\s*"))
skill_df <- as.data.frame(table(skill_freq)) %>% arrange(desc(Freq)) %>% head(10)

ggplot(skill_df, aes(x = reorder(skill_freq, Freq), y = Freq)) +
  geom_col(fill = "#2E86C1") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top Skills in Demand", x = "Skill", y = "Frequency")

# ===============================
# 8. INTERACTIVE TABLE
# ===============================
datatable(df[, c("job_title", "company_name", "location", "experience_level", "skills")],
          options = list(pageLength = 10), caption = "LinkedIn Job Postings Table")

# ===============================
# 9. TIME SERIES ANALYSIS (Optional)
# ===============================
if ("posted_date" %in% colnames(df)) {
  daily_posts <- df %>%
    group_by(posted_date) %>%
    summarise(count = n())

  ggplot(daily_posts, aes(x = posted_date, y = count)) +
    geom_line(color = "#E74C3C") +
    theme_minimal() +
    labs(title = "Job Postings Over Time", x = "Date", y = "Count")
}

# ===============================
# 10. EXPORT CLEANED DATA
# ===============================
write.csv(df, "linkedin_cleaned_2024_25.csv", row.names = FALSE)

# ===============================
# 11. CONCLUSION
# ===============================
cat("✅ Analysis complete. Data cleaned, visualized, and exported.")