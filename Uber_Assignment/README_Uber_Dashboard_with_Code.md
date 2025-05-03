
# 🚕 Uber Trips Dashboard (April–September 2014)

🔗 **Live Dashboard:** [http://nabykarki21.shinyapps.io/uber_assignment](http://nabykarki21.shinyapps.io/uber_assignment)

## Contributor ✍️  
Naby Karki

---

## 📁 File Structure

```
Uber_Assignment/
├── Uber_Assignment.R              
├── Uber_ReadMe.md                 
├── uber-raw-data-apr14.zip        
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
# see load_uber_data() in Uber_Assignment.R
```

---

## 📊 Trips by Hour

```r
output$hour_plot <- renderPlot({
  df <- filtered_data() %>% count(hour)
  threshold <- quantile(df$n, 0.75)
  df$peak <- df$n > threshold
  ggplot(df, aes(hour, n, fill = peak)) +
    geom_col() +
    scale_fill_manual(values = c("FALSE" = "#0073C2FF", "TRUE" = "red")) +
    labs(title = "Total Trips by Hour (Red = Peak Hour)",
         subtitle = "Top 25% hours in red", x = "Hour", y = "Trips") +
    theme_minimal() +
    theme(legend.position = "none")
})
```

---

## 📊 Trips by Hour and Month

```r
output$hour_month_plot <- renderPlot({
  filtered_data() %>% count(month, hour) %>%
    ggplot(aes(hour, n, fill = month)) +
    geom_col(position = "dodge") +
    facet_wrap(~ month) +
    labs(title = "Trips by Hour by Month", x = "Hour", y = "Trips") +
    theme_minimal()
})
```

---

## 📊 Trips by Day

```r
output$day_plot <- renderPlot({
  filtered_data() %>% count(day) %>%
    ggplot(aes(day, n)) +
    geom_col(fill = "orange") +
    labs(title = "Trips per Day of Month", x = "Day", y = "Trips") +
    theme_minimal()
})
```

---

## 📋 Table: Trips per Day

```r
output$day_table <- renderDataTable({
  filtered_data() %>% count(day) %>% rename(Day = day, Trips = n)
})
```

---

## 📊 Trips by Day of Week and Month

```r
output$day_month_plot <- renderPlot({
  filtered_data() %>% count(month, wday) %>%
    ggplot(aes(wday, n, fill = month)) +
    geom_col(position = "dodge") +
    labs(title = "Trips by Day of Week and Month", x = "Day of Week", y = "Trips") +
    theme_minimal()
})
```

---

## 📊 Trips by Base and Month

```r
output$base_month_plot <- renderPlot({
  filtered_data() %>% count(base, month) %>%
    ggplot(aes(base, n, fill = month)) +
    geom_col(position = "dodge") +
    labs(title = "Trips by Base and Month", x = "Base", y = "Trips") +
    theme_minimal()
})
```

---

## 🌡️ Heatmaps

```r
output[[output_id]] <- renderPlot({
  df <- uber_data %>% filter(month == m) %>%
    drop_na(hour, day, wday, month, week, base) %>%
    sample_n(min(5000, n()))
  ht <- input$heat_type
  row_var <- switch(ht, "hour_day" = "wday", "month_day" = "day",
                    "month_week" = "week", "base_day" = "base")
  col_var <- switch(ht, "hour_day" = "hour", "month_day" = "month",
                    "month_week" = "month", "base_day" = "wday")
  mat <- dcast(df, as.formula(paste(row_var, "~", col_var)), length)
  mat[is.na(mat)] <- 0
  mat_melt <- melt(mat, id.vars = row_var)
  ggplot(mat_melt, aes(variable, .data[[row_var]], fill = value)) +
    geom_tile(color = "white") +
    scale_fill_viridis_c() +
    labs(title = paste("Heatmap:", m), x = col_var, y = row_var, fill = "Trips") +
    theme_minimal()
})
```

---

## 🗺️ Leaflet Map

```r
output[[output_id]] <- renderLeaflet({
  samp <- uber_data %>% filter(month == m) %>%
    drop_na(lat, lon) %>%
    sample_n(min(5000, n()))
  leaflet(samp) %>%
    addTiles() %>%
    addCircleMarkers(
      lng = ~lon, lat = ~lat, radius = 3,
      stroke = FALSE, fillOpacity = 0.4,
      clusterOptions = markerClusterOptions()
    )
})
```

---

## 🤖 Prediction Model

```r
output$model_summary <- renderPrint({
  md <- filtered_data() %>% count(hour, wday) %>% sample_n(min(5000, n()))
  md$wday <- as.numeric(factor(md$wday, levels = levels(uber_data$wday)))
  md$peak <- factor(ifelse(md$n > quantile(md$n, 0.75), "Yes", "No"))
  fit <- train(peak ~ hour + wday, data = md, method = "rpart",
               trControl = trainControl(method = "cv", number = 5))
  print(fit)
})
```

---

## 🌲 Decision Tree Plot

```r
output$model_plot <- renderPlot({
  md <- filtered_data() %>% count(hour, wday) %>% sample_n(min(5000, n()))
  md$wday <- as.numeric(factor(md$wday, levels = levels(uber_data$wday)))
  md$peak <- factor(ifelse(md$n > quantile(md$n, 0.75), "Yes", "No"))
  fit <- train(peak ~ hour + wday, data = md, method = "rpart")
  rpart.plot(fit$finalModel,
             main = "Decision Tree for Predicting Peak Hours",
             sub = "Split rules based on hour and weekday")
})
```

---

## 📊 Pivot Table

```r
output$pivot_table <- renderDT({
  if (input$selected_months_pivot == "All") {
    df <- uber_data
  } else {
    df <- uber_data %>% filter(month == input$selected_months_pivot)
  }
  pivot <- df %>% count(month, hour) %>%
    pivot_wider(names_from = hour, values_from = n, values_fill = 0) %>%
    arrange(match(month, month.name[4:9]))
  datatable(pivot, options = list(pageLength = 6), rownames = FALSE)
})
```

---

