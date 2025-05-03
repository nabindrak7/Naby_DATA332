
# 🚕 Uber Trips Dashboard (April–September 2014)

🔗 **Live Dashboard:** [http://nabykarki21.shinyapps.io/uber_assignment](http://nabykarki21.shinyapps.io/uber_assignment)

## Contributor ✍️  
Naby Karki

---

## 📁 File Structure

```
Uber_Assignment/
├── Uber_Assignment.R              # Main Shiny app script
├── Uber_ReadMe.md                 # Project README file
├── uber-raw-data-apr14.zip        # Monthly ZIP data
├── uber-raw-data-may14.zip
├── uber-raw-data-jun14.zip
├── uber-raw-data-jul14.zip
├── uber-raw-data-aug14.zip
├── uber-raw-data-sep14.zip
```

---

## Introduction  
This project analyzes Uber trip data collected in New York City between April and September 2014. It identifies trends in ride activity by time of day, day of week, and base. With preprocessing, visualizations, mapping, and a prediction model, this dashboard helps understand and explore ride demand across months.

---

## 📌 Objective

The dashboard provides interactive plots, heatmaps, geospatial maps, and a decision tree prediction model to analyze Uber trip patterns and predict peak hours.

---

## 📁 Data Loading & Preprocessing

```r
# See full script in Uber_Assignment.R
```

**Description**:  
Downloads and loads Uber trip data from 6 monthly `.zip` files, processes date-time and location fields, and creates useful time-based columns like `hour`, `day`, `wday`, `month`, and `week`.

---

## 📊 Trips by Hour  
Displays total trip volume by hour across all days. Red bars indicate the busiest 25% of hours.

## 📊 Trips by Hour + Month  
Grouped bar chart that compares hourly trip trends between months (April–September).

## 📊 Trips by Day  
Shows trip volume per calendar day (1–31) for the selected month.

## 📋 Table: Trips per Day  
Provides a sortable table of daily trip counts.

## 📊 Trips by Day of Week + Month  
Compares trip volumes across weekdays and weekends, split by month.

## 📊 Trips by Base + Month  
Visualizes how many trips originated from each Uber base across different months.

---

## 🌡️ Heatmaps (Interactive by Month)

Four types of heatmaps:
- Hour vs Day
- Month vs Day
- Month vs Week
- Base vs Day of Week

These help spot correlations and high-density patterns across time and location.

---

## 🗺️ Leaflet Map

For each month, an interactive map clusters pickup points using Leaflet, helping users visualize the spatial distribution of Uber demand in NYC.

---

## 🤖 Prediction Model

A decision tree model (`rpart`) trained using hour and weekday predicts whether a time is a "peak" ride hour.

- Uses 5-fold cross-validation via `caret`
- Model output is shown as both text and a tree plot

---

## 📊 Pivot Table

Interactive pivot table that displays trip count by hour across months. Users can filter by individual month or view all.

---  
