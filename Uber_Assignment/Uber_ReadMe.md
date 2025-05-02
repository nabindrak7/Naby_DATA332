# 🚕 Uber Trips Dashboard (April–September 2014)
![3e8eb2ffab960f9c8970ebd0e2db277d](https://github.com/user-attachments/assets/57dcc64e-3a59-4804-bde3-b576db18dc82)

## 📌 Objective

This Shiny dashboard visualizes Uber pickup data from April to September 2014. It provides interactive charts, heatmaps, a geospatial map, and a machine learning prediction model to analyze ride patterns by hour, day, base, and month, and to predict peak hours.

---

## 📁 Data Loading & Preprocessing

```r
load_uber_data <- function() {
  months <- c("apr14", "may14", "jun14", "jul14", "aug14", "sep14")
  base_url <- "https://github.com/nabindrak7/Naby_DATA332/raw/96371d22ee71ad11a0b910912c19002ebbb0be86/Uber_Assignment/"
  tmp_dir <- tempdir()
  all_data <- vector("list", length(months))

  for (i in seq_along(months)) {
    mcode <- months[i]
    zip_path <- file.path(tmp_dir, paste0("uber-", mcode, ".zip"))
    download.file(paste0(base_url, "uber-raw-data-", mcode, ".zip"), zip_path, mode = "wb")
    unzip(zip_path, exdir = tmp_dir)
    csvs <- list.files(tmp_dir, pattern = paste0(mcode, ".*\.csv$"), full.names = TRUE)
    if (length(csvs) == 1) {
      df <- read_csv(csvs, show_col_types = FALSE) %>% clean_names()
      if (all(c("lat", "lon", "date_time") %in% names(df))) {
        df <- df %>%
          mutate(
            lat = as.numeric(lat),
            lon = as.numeric(lon),
            date_time = mdy_hms(date_time),
            hour = hour(date_time),
            day = day(date_time),
            wday = wday(date_time, label = TRUE, abbr = FALSE),
            month = month(date_time, label = TRUE, abbr = FALSE),
            week = week(date_time)
          ) %>%
          drop_na(date_time, lat, lon)
        all_data[[i]] <- df
      }
    }
  }
  bind_rows(all_data)
}
```

**Description**:  
Downloads and processes Uber trip data. Extracts date/time components to enable further visualization.

---

## 📊 Chart 1: Trips by Hour

```r
output$hour_plot <- renderPlot({
  df <- filtered_data() %>% count(hour)
  threshold <- quantile(df$n, 0.75)
  df$peak <- df$n > threshold
  ggplot(df, aes(hour, n, fill = peak)) +
    geom_col() +
    scale_fill_manual(values = c("FALSE" = "#0073C2FF", "TRUE" = "red")) +
    labs(title = "Total Trips by Hour (Red = Peak Hour)",
         subtitle = "Displays hourly ride volume. Red bars indicate top 25% busiest hours.",
         x = "Hour of Day", y = "Trips") +
    theme_minimal() +
    theme(legend.position = "none")
})
```

**Description**:  
Shows how ride volume varies by hour. Highlights peak hours.

---

## 📊 Chart 2: Trips by Hour and Month

```r
output$hour_month_plot <- renderPlot({
  filtered_data() %>%
    count(month, hour) %>%
    ggplot(aes(hour, n, fill = month)) +
    geom_col(position = "dodge") +
    facet_wrap(~ month) +
    labs(title = "Trips by Hour for Selected Months",
         subtitle = "Each facet represents a month with trips by hour.",
         x = "Hour", y = "Trips") +
    theme_minimal()
})
```

**Description**:  
Hourly ride trends separated by month for deeper temporal comparison.

---

## 📊 Chart 3: Trips by Day

```r
output$day_plot <- renderPlot({
  filtered_data() %>%
    count(day) %>%
    ggplot(aes(day, n)) +
    geom_col(fill = "orange") +
    labs(title = "Trips per Day of the Month",
         subtitle = "Total Uber trips for each calendar day (1–31).",
         x = "Day", y = "Trips") +
    theme_minimal()
})
```

**Description**:  
Daily trip totals for all days in the month.

---

## 📋 Table: Trips per Day

```r
output$day_table <- renderDataTable({
  filtered_data() %>% count(day) %>% rename(Day = day, Trips = n)
})
```

**Description**:  
Table format of the trip totals by day of the month.

---

## 📊 Chart 4: Trips by Day of Week and Month

```r
output$day_month_plot <- renderPlot({
  filtered_data() %>%
    count(month, wday) %>%
    ggplot(aes(wday, n, fill = month)) +
    geom_col(position = "dodge") +
    labs(title = "Trips by Day of Week and Month",
         subtitle = "Compares day-of-week trip totals across months.",
         x = "Day of Week", y = "Trips") +
    theme_minimal()
})
```

**Description**:  
Analyzes ride frequency per day of the week, broken down by month.

---

## 📊 Chart 5: Trips by Base and Month

```r
output$base_month_plot <- renderPlot({
  filtered_data() %>%
    count(base, month) %>%
    ggplot(aes(base, n, fill = month)) +
    geom_col(position = "dodge") +
    labs(title = "Trips by Base and Month",
         subtitle = "Each bar shows total trips per base (e.g., B02512), grouped by month.",
         x = "Base", y = "Trips") +
    theme_minimal()
})
```

**Description**:  
Distribution of trips based on dispatch base, across all months.

---

## 🌡️ Heatmaps (4 Types)

```r
# Example of heatmap rendering
ggplot(mat_melt, aes(variable, .data[[row_var]], fill = value)) +
  geom_tile(color = "white") +
  scale_fill_viridis_c() +
  labs(title = paste("Heatmap:", input$heat_type),
       subtitle = "Color intensity represents trip count for the selected time combination.",
       x = names(mat)[2], y = row_var, fill = "Trips") +
  theme_minimal()
```

**Types**:
- Hour vs Day (`wday ~ hour`)
- Month vs Day (`day ~ month`)
- Month vs Week (`week ~ month`)
- Base vs Day of Week (`base ~ wday`)

**Description**:  
Each heatmap visualizes the density of trips across time or dispatch base dimensions.

---

## 🗺️ Leaflet Map

```r
output$map <- renderLeaflet({
  samp <- filtered_data() %>% drop_na(lat, lon) %>% sample_n(min(20000, n()))
  leaflet(samp) %>%
    addTiles() %>%
    addCircleMarkers(
      lng = ~lon,
      lat = ~lat,
      radius = 3,
      stroke = FALSE,
      fillOpacity = 0.4,
      clusterOptions = markerClusterOptions()
    )
})
```

**Description**:  
An interactive leaflet map showing sampled pickup locations with clustering enabled.

---

## 🤖 Prediction Model

```r
output$model_summary <- renderPrint({
  md <- filtered_data() %>% count(hour, wday) %>% sample_n(min(20000, n()))
  md$wday <- as.numeric(factor(md$wday, levels = levels(uber_data$wday)))
  md$peak <- ifelse(md$n > quantile(md$n, 0.75), "Yes", "No")
  md$peak <- factor(md$peak)
  ctrl <- trainControl(method = "cv", number = 5)
  fit <- train(peak ~ hour + wday, data = md, method = "rpart", trControl = ctrl)
  print(fit)
})
```

**Description**:  
Trains a decision tree model using hour and day of week to predict whether a given time is a "peak hour".

---

## 🌲 Decision Tree Plot

```r
output$model_plot <- renderPlot({
  md <- filtered_data() %>% count(hour, wday) %>% sample_n(min(20000, n()))
  md$wday <- as.numeric(factor(md$wday, levels = levels(uber_data$wday)))
  md$peak <- ifelse(md$n > quantile(md$n, 0.75), "Yes", "No")
  md$peak <- factor(md$peak)
  fit <- train(peak ~ hour + wday, data = md, method = "rpart")
  rpart.plot::rpart.plot(fit$finalModel,
    main = "Decision Tree for Predicting Peak Hours",
    sub = "Based on hour and day of week. Split nodes show conditions for 'Peak'.")
})
```

**Description**:  
Visualizes the decision tree model with conditions used to determine peak-hour classification.

---
