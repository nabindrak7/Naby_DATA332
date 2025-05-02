# 🚕 Uber Trips Dashboard (April–September 2014)

## 📌 Objective

This Shiny dashboard visualizes Uber pickup data from April to September 2014. It provides interactive charts, heatmaps, a geospatial map, and a machine learning prediction model to analyze ride patterns by hour, day, base, and month, and to predict peak hours.

---

## 📁 Data Loading & Preprocessing

```r
load_uber_data <- function() {
  # Function downloads, unzips, reads, and cleans Uber data
}
```

**Description**: Downloads and processes Uber trip data, converting date strings and creating time-based columns.

---

## 📊 Charts and Visualizations

### Trips by Hour

```r
output$hour_plot <- renderPlot({
  # Plots hourly trip volume and highlights peak hours
})
```

### Trips by Hour and Month

```r
output$hour_month_plot <- renderPlot({
  # Shows hourly distribution faceted by month
})
```

### Trips by Day

```r
output$day_plot <- renderPlot({
  # Daily trip counts per day of the month
})
```

### Trips by Day Table

```r
output$day_table <- renderDataTable({
  # Tabular format of daily trip counts
})
```

### Trips by Day of Week and Month

```r
output$day_month_plot <- renderPlot({
  # Grouped bar chart of weekdays colored by month
})
```

### Trips by Base and Month

```r
output$base_month_plot <- renderPlot({
  # Shows base-wise monthly trip distribution
})
```

---

## 🌡️ Heatmaps

```r
# Rendered using dcast() + ggplot heatmap tiles
```

**Types**:
- Hour vs Day
- Month vs Day
- Month vs Week
- Base vs Day of Week

---

## 🗺️ Leaflet Map

```r
output$map <- renderLeaflet({
  # Interactive cluster map of Uber pickups
})
```

---

## 🤖 Prediction Model (Peak Hour Classifier)

```r
output$model_summary <- renderPrint({
  # caret::train on hour + weekday to predict 'Peak'
})
```

### Model Plot

```r
output$model_plot <- renderPlot({
  # rpart decision tree showing split rules for peak classification
})
```
