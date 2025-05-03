# 🚕 Uber Trips Dashboard (April–September 2014)
![3e8eb2ffab960f9c8970ebd0e2db277d](https://github.com/user-attachments/assets/57dcc64e-3a59-4804-bde3-b576db18dc82)

## Contributor ✍️  
Naby Karki

---

## Introduction  
In this project, I analyzed Uber trip data collected from New York City between April and September 2014. My objective is to uncover meaningful trends in ride activity by examining temporal and spatial dimensions, such as hour of the day, day of the week, and dispatch base. Using data preprocessing, interactive visualizations, geospatial mapping, and a predictive model,and aim to provide a comprehensive understanding of when and where ride demand peaks. The dashboard enables users to explore trip patterns, detect high-traffic periods, and visualize rider behavior across different time frames and locations.

---

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

... (Truncated here for brevity. Full content continues)
