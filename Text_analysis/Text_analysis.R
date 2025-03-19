
# Load necessary libraries
library(tidyverse)
library(tidytext)
library(wordcloud)
library(RColorBrewer)
library(syuzhet)
library(ggplot2)
library(lubridate)

# Install and load textdata package for NRC lexicon
if(!require(textdata)) {
  install.packages("textdata")
  library(textdata)
}
get_sentiments("nrc")

# Set working directory
setwd("C:/Users/nabin/OneDrive/Documents/r_projects/Text_analysis")

# Load data
complaints <- read.csv("Text_analysis.csv", stringsAsFactors = FALSE)

# Filter out rows with non-empty complaint narratives
complaints_clean <- complaints %>%
  filter(!is.na(Consumer.complaint.narrative))

# Remove rows where the complaint narrative contains the word 'xxxx'
complaints_clean <- complaints_clean %>%
  filter(!str_detect(tolower(Consumer.complaint.narrative), "\bxxxx\b"))

# Data Cleanup:
# Convert text to lowercase, remove punctuation, numbers, stopwords, and exclude specific word 'xxxx'
cleaned_narratives <- complaints_clean %>%
  select(Complaint.ID, Product, Issue, Date.received, Consumer.complaint.narrative) %>%
  unnest_tokens(word, Consumer.complaint.narrative) %>%
  anti_join(stop_words) %>%
  filter(!str_detect(word, "^[0-9]+$")) %>%
  filter(word != "xxxx")

# Create Images folder if not exists
if(!dir.exists("Images")){
  dir.create("Images")
}

# WORD CLOUD
word_freq <- cleaned_narratives %>%
  count(word, sort = TRUE)

png("Images/wordcloud.png", width = 800, height = 600)
wordcloud(words = word_freq$word, freq = word_freq$n, min.freq = 50, 
          max.words = 200, colors = brewer.pal(8, "Dark2"))
dev.off()

# SENTIMENT ANALYSIS - BING
bing_sentiment <- cleaned_narratives %>%
  inner_join(get_sentiments("bing")) %>%
  count(sentiment) %>%
  mutate(percent = n / sum(n) * 100)

png("Images/sentiment_bing.png", width = 800, height = 600)
ggplot(bing_sentiment, aes(x = sentiment, y = n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  labs(title = "Sentiment Analysis using Bing Lexicon", y = "Word Count", x = "Sentiment") +
  theme_minimal()
dev.off()

# SENTIMENT ANALYSIS - NRC
nrc_sentiment <- cleaned_narratives %>%
  inner_join(get_sentiments("nrc")) %>%
  count(sentiment) %>%
  mutate(percent = n / sum(n) * 100)

png("Images/sentiment_nrc.png", width = 1000, height = 600)
ggplot(nrc_sentiment, aes(x = reorder(sentiment, n), y = n, fill = sentiment)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Sentiment Analysis using NRC Lexicon", y = "Word Count", x = "Emotion") +
  theme_minimal()
dev.off()

# TOP 10 COMPLAINT PRODUCTS
product_complaints <- complaints_clean %>%
  count(Product, sort = TRUE) %>%
  top_n(10)

png("Images/top_products.png", width = 800, height = 600)
ggplot(product_complaints, aes(x = reorder(Product, n), y = n, fill = Product)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 10 Complaint Products", y = "Number of Complaints", x = "Product") +
  theme_minimal() +
  theme(legend.position = "none")
dev.off()

# TOP 10 ISSUES
issue_complaints <- complaints_clean %>%
  count(Issue, sort = TRUE) %>%
  top_n(10)

png("Images/top_issues.png", width = 800, height = 600)
ggplot(issue_complaints, aes(x = reorder(Issue, n), y = n, fill = Issue)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Top 10 Complaint Issues", y = "Number of Complaints", x = "Issue") +
  theme_minimal() +
  theme(legend.position = "none")
dev.off()

# TREND OVER TIME - COMPLAINT COUNTS
complaints_clean$Date.received <- mdy(complaints_clean$Date.received)
time_trend <- complaints_clean %>%
  mutate(year = year(Date.received)) %>%
  count(year)

png("Images/complaints_over_time.png", width = 800, height = 600)
ggplot(time_trend, aes(x = year, y = n)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_point(color = "red", size = 2) +
  labs(title = "Trend of Complaints Over Time", y = "Number of Complaints", x = "Year") +
  theme_minimal()
dev.off()

# Save cleaned narrative data for documentation
write.csv(cleaned_narratives, "Cleaned_Narratives.csv", row.names = FALSE)

# End of script
