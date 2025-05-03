# --- Load Required Libraries ---
library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)
library(janitor)
library(tidyr)
library(DT)
library(leaflet)
library(leaflet.extras)
library(caret)
library(reshape2)
library(rpart.plot)

# --- Load & Preprocess Data ---
load_uber_data <- function() {
  months <- c("apr14", "may14", "jun14", "jul14", "aug14", "sep14")
  base_url <- "https://github.com/nabindrak7/Naby_DATA332/raw/96371d22ee71ad11a0b910912c19002ebbb0be86/Uber_Assignment/"
  tmp_dir <- tempdir()
  all_data <- list()
  
  for (i in seq_along(months)) {
    mcode <- months[i]
    zip_path <- file.path(tmp_dir, paste0("uber-", mcode, ".zip"))
    download.file(paste0(base_url, "uber-raw-data-", mcode, ".zip"), zip_path, mode = "wb")
    unzip(zip_path, exdir = tmp_dir)
    csvs <- list.files(tmp_dir, pattern = paste0(mcode, ".*\\.csv$"), full.names = TRUE)
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

uber_data <- load_uber_data()
available_months <- sort(unique(uber_data$month))

# --- UI ---
ui <- fluidPage(
  titlePanel("Uber Trips Dashboard (Apr–Sep 2014)"),
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition = "!(input.tabs == 'Heatmaps' || input.tabs == 'Map' || input.tabs == 'Pivot Table')",
        selectInput("selected_months", "Select Month:",
                    choices = as.character(available_months),
                    selected = as.character(available_months[1]))
      ),
      conditionalPanel(
        condition = "input.tabs == 'Pivot Table'",
        selectInput("selected_months_pivot", "Select Month:",
                    choices = c("All", as.character(available_months)),
                    selected = "All")
      ),
      conditionalPanel(
        condition = "input.tabs == 'Heatmaps'",
        selectInput("heat_type", "Heatmap Type:",
                    choices = c("Hour vs Day" = "hour_day",
                                "Month vs Day" = "month_day",
                                "Month vs Week" = "month_week",
                                "Base vs Day" = "base_day"))
      )
    ),
    mainPanel(
      tabsetPanel(id = "tabs",
                  tabPanel("Trips by Hour",
                           helpText("This bar chart shows total Uber trips by hour of the day. Red bars represent the top 25% busiest hours (peak hours)."),
                           plotOutput("hour_plot")),
                  tabPanel("Trips by Hour + Month",
                           helpText("This grouped bar chart displays hourly trip counts for each month, helping compare daily demand patterns month-to-month."),
                           plotOutput("hour_month_plot")),
                  tabPanel("Trips by Day",
                           helpText("This chart shows the number of trips taken each day of the month for the selected month."),
                           plotOutput("day_plot"),
                           dataTableOutput("day_table")),
                  tabPanel("Trips by Day + Month",
                           helpText("This chart compares trip counts by weekday across months to spot weekday/weekend trends."),
                           plotOutput("day_month_plot")),
                  tabPanel("Trips by Base + Month",
                           helpText("Displays how many trips originated from each Uber base during each month."),
                           plotOutput("base_month_plot")),
                  tabPanel("Heatmaps",
                           tabsetPanel(id = "heatmap_subtab",
                                       tabPanel("April",
                                                helpText("Heatmap for April: visualizes relationships based on selected variables (e.g., Hour vs Day, Month vs Week, etc.)."),
                                                plotOutput("heatmap_April")),
                                       tabPanel("May",
                                                helpText("Heatmap for May: visualizes relationships based on selected variables (e.g., Hour vs Day, Month vs Week, etc.)."),
                                                plotOutput("heatmap_May")),
                                       tabPanel("June",
                                                helpText("Heatmap for June: visualizes relationships based on selected variables (e.g., Hour vs Day, Month vs Week, etc.)."),
                                                plotOutput("heatmap_June")),
                                       tabPanel("July",
                                                helpText("Heatmap for July: visualizes relationships based on selected variables (e.g., Hour vs Day, Month vs Week, etc.)."),
                                                plotOutput("heatmap_July")),
                                       tabPanel("August",
                                                helpText("Heatmap for August: visualizes relationships based on selected variables (e.g., Hour vs Day, Month vs Week, etc.)."),
                                                plotOutput("heatmap_August")),
                                       tabPanel("September",
                                                helpText("Heatmap for September: visualizes relationships based on selected variables (e.g., Hour vs Day, Month vs Week, etc.)."),
                                                plotOutput("heatmap_September"))
                           )),
                  tabPanel("Map",
                           tabsetPanel(id = "map_subtab",
                                       tabPanel("April",
                                                helpText("Leaflet map of Uber pickup locations in April. Clusters represent areas with high pickup density."),
                                                leafletOutput("map_April", height = "600px")),
                                       tabPanel("May",
                                                helpText("Leaflet map of Uber pickup locations in May. Clusters represent areas with high pickup density."),
                                                leafletOutput("map_May", height = "600px")),
                                       tabPanel("June",
                                                helpText("Leaflet map of Uber pickup locations in June. Clusters represent areas with high pickup density."),
                                                leafletOutput("map_June", height = "600px")),
                                       tabPanel("July",
                                                helpText("Leaflet map of Uber pickup locations in July. Clusters represent areas with high pickup density."),
                                                leafletOutput("map_July", height = "600px")),
                                       tabPanel("August",
                                                helpText("Leaflet map of Uber pickup locations in August. Clusters represent areas with high pickup density."),
                                                leafletOutput("map_August", height = "600px")),
                                       tabPanel("September",
                                                helpText("Leaflet map of Uber pickup locations in September. Clusters represent areas with high pickup density."),
                                                leafletOutput("map_September", height = "600px"))
                           )),
                  tabPanel("Prediction",
                           helpText("A decision tree model predicts peak ride hours based on weekday and hour. Visualization shows how the tree splits."),
                           plotOutput("model_plot"),
                           verbatimTextOutput("model_summary")),
                  tabPanel("Pivot Table",
                           helpText("Pivot table showing trip counts by hour for each month. Use the dropdown to filter by month."),
                           DTOutput("pivot_table"))
      )
    )
  )
)

# --- Server ---
# (Server logic remains unchanged from your original code)

# --- Run App ---
# shinyApp(ui, server)


# --- Server ---
server <- function(input, output, session) {
  filtered_data <- reactive({
    req(input$selected_months)
    uber_data %>% filter(month == input$selected_months)
  })
  
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
  
  output$hour_month_plot <- renderPlot({
    filtered_data() %>% count(month, hour) %>%
      ggplot(aes(hour, n, fill = month)) +
      geom_col(position = "dodge") +
      facet_wrap(~ month) +
      labs(title = "Trips by Hour by Month", x = "Hour", y = "Trips") +
      theme_minimal()
  })
  
  output$day_plot <- renderPlot({
    filtered_data() %>% count(day) %>%
      ggplot(aes(day, n)) +
      geom_col(fill = "orange") +
      labs(title = "Trips per Day of Month", x = "Day", y = "Trips") +
      theme_minimal()
  })
  
  output$day_table <- renderDataTable({
    filtered_data() %>% count(day) %>% rename(Day = day, Trips = n)
  })
  
  output$day_month_plot <- renderPlot({
    filtered_data() %>% count(month, wday) %>%
      ggplot(aes(wday, n, fill = month)) +
      geom_col(position = "dodge") +
      labs(title = "Trips by Day of Week and Month", x = "Day of Week", y = "Trips") +
      theme_minimal()
  })
  
  output$base_month_plot <- renderPlot({
    filtered_data() %>% count(base, month) %>%
      ggplot(aes(base, n, fill = month)) +
      geom_col(position = "dodge") +
      labs(title = "Trips by Base and Month", x = "Base", y = "Trips") +
      theme_minimal()
  })
  
  # --- Monthly Heatmaps ---
  for (month_name in month.name[4:9]) {
    local({
      m <- month_name
      output_id <- paste0("heatmap_", m)
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
    })
  }
  
  # --- Monthly Maps ---
  for (month_name in month.name[4:9]) {
    local({
      m <- month_name
      output_id <- paste0("map_", m)
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
    })
  }
  
  output$model_summary <- renderPrint({
    md <- filtered_data() %>% count(hour, wday) %>% sample_n(min(5000, n()))
    md$wday <- as.numeric(factor(md$wday, levels = levels(uber_data$wday)))
    md$peak <- factor(ifelse(md$n > quantile(md$n, 0.75), "Yes", "No"))
    fit <- train(peak ~ hour + wday, data = md, method = "rpart",
                 trControl = trainControl(method = "cv", number = 5))
    print(fit)
  })
  
  output$model_plot <- renderPlot({
    md <- filtered_data() %>% count(hour, wday) %>% sample_n(min(5000, n()))
    md$wday <- as.numeric(factor(md$wday, levels = levels(uber_data$wday)))
    md$peak <- factor(ifelse(md$n > quantile(md$n, 0.75), "Yes", "No"))
    fit <- train(peak ~ hour + wday, data = md, method = "rpart")
    rpart.plot(fit$finalModel,
               main = "Decision Tree for Predicting Peak Hours",
               sub = "Split rules based on hour and weekday")
  })
  
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
}

# --- Run App ---
shinyApp(ui, server)
