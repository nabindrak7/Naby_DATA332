# Consumer Complaints Analysis 📊

## Contributors 🙌
Nabin Basnet

## Introduction
This project conducts a detailed analysis of consumer complaints data, focusing on identifying trends, key complaint categories, and sentiment analysis. Using text mining and visualization techniques, we analyze the issues, products, and emotions expressed by consumers.

<div align = "center">
<img src = "Images/complaints_over_time.png" width = "500">
</div>

---

## Data Cleaning 🧹

To prepare the data for meaningful analysis, we performed the following cleanup steps:

1. **Filtering Empty Narratives:**  
   - Removed rows where `Consumer.complaint.narrative` was empty to ensure valid text data for sentiment analysis.
  
2. **Removing Placeholder Text ('xxxx'):**  
   - Excluded rows containing 'xxxx' to eliminate redacted information.
  
3. **Tokenization:**  
   - Broke down complaint narratives into individual words using `unnest_tokens()`.

4. **Stopwords and Number Removal:**  
   - Removed common stopwords and numeric values to focus on significant terms.

5. **Excluded Specific Words:**  
   - Filtered out the word 'xxxx' post-tokenization.

```r
complaints_clean <- complaints %>%
  filter(!is.na(Consumer.complaint.narrative)) %>%
  filter(!str_detect(tolower(Consumer.complaint.narrative), "xxxx"))

cleaned_narratives <- complaints_clean %>%
  select(Complaint.ID, Product, Issue, Date.received, Consumer.complaint.narrative) %>%
  unnest_tokens(word, Consumer.complaint.narrative) %>%
  anti_join(stop_words) %>%
  filter(!str_detect(word, "^[0-9]+$")) %>%
  filter(word != "xxxx")
```

---

## Data Visualizations 📊

### 1. Trend of Complaints Over Time
<div align = "center">
<img src = "Images/complaints_over_time.png" width = "700">
</div>

* **Why Chosen:**  
   Shows complaint trends year over year.
* **Insight:**  
   Noticeable growth until 2015 indicates increased consumer dissatisfaction or awareness.

---

### 2. Sentiment Analysis using Bing Lexicon
<div align = "center">
<img src = "Images/sentiment_bing.png" width = "600">
</div>

* **Why Chosen:**  
   Displays positive vs. negative sentiment breakdown.
* **Insight:**  
   Negative sentiment is dominant, signaling widespread consumer dissatisfaction.

---

### 3. Sentiment Analysis using NRC Lexicon
<div align = "center">
<img src = "Images/sentiment_nrc.png" width = "800">
</div>

* **Why Chosen:**  
   Breaks down emotions like trust, anger, and joy for a nuanced analysis.
* **Insight:**  
   Trust and positive emotions exist alongside frustration, offering a broader emotional context.

---

### 4. Top 10 Complaint Issues
<div align = "center">
<img src = "Images/top_issues.png" width = "700">
</div>

* **Why Chosen:**  
   Highlights the most common complaint issues.
* **Insight:**  
   Loan modification and credit report issues dominate, providing clear targets for improvement.

---

### 5. Top 10 Complaint Products
<div align = "center">
<img src = "Images/top_products.png" width = "700">
</div>

* **Why Chosen:**  
   Identifies products receiving the most complaints.
* **Insight:**  
   Mortgage and debt collection issues stand out, signaling the need for better customer service and policies.

---

### 6. Word Cloud of Complaint Narratives
<div align = "center">
<img src = "Images/wordcloud.png" width = "600">
</div>

* **Why Chosen:**  
   Visualizes frequently mentioned terms in complaints.
* **Insight:**  
   Words like **account**, **credit**, **payment**, and **debt** highlight key themes of consumer concerns.

---

## Tools & Libraries Used 🛠️

* **tidyverse**: Data manipulation and visualization
* **tidytext**: Text mining and tokenization
* **ggplot2**: Visualization
* **syuzhet**: Sentiment analysis
* **wordcloud**: Word cloud generation
* **lubridate**: Date handling

---

## Project Structure 📁

```
📁 Consumer_Complaints_Analysis
 ┣ 📂 Images
 ┃ ┣ 📄 complaints_over_time.png
 ┃ ┣ 📄 sentiment_bing.png
 ┃ ┣ 📄 sentiment_nrc.png
 ┃ ┣ 📄 top_issues.png
 ┃ ┣ 📄 top_products.png
 ┃ ┣ 📄 wordcloud.png
 ┣ 📄 Consumer_Complaints_Analysis.R
 ┣ 📄 Cleaned_Narratives.csv
 ┣ 📄 README.md
```

---

## Conclusion ✅

The analysis reveals valuable insights into consumer dissatisfaction trends, major complaint categories, and the sentiments expressed by customers. The findings serve as actionable intelligence for improving financial products and services.
