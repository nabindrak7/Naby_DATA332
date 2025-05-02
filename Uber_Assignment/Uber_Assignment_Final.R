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
  months   <- c("apr14", "may14", "jun14", "jul14", "aug14", "sep14")
  base_url <- "https://github.com/nabindrak7/Naby_DATA332/raw/96371d22ee71ad11a0b910912c19002ebbb0be86/Uber_Assignment/"
  tmp_dir  <- tempdir()
  all_data <- vector("list", length(months))
  
  for (i in seq_along(months)) {
    mcode    <- months[i]
    zip_path <- file.path(tmp_dir, paste0("uber-", mcode, ".zip"))
    download.file(paste0(base_url, "uber-raw-data-", mcode, ".zip"), zip_path, mode = "wb")
    unzip(zip_path, exdir = tmp_dir)
    csvs <- list.files(tmp_dir, pattern = paste0(mcode, ".*\\.csv$"), full.names = TRUE)
    if (length(csvs) == 1) {
      df <- read_csv(csvs, show_col_types = FALSE) %>%
        clean_names()
      if (all(c("lat", "lon", "date_time") %in% names(df))) {
        df <- df %>%
          mutate(
            lat       = as.numeric(lat),
            lon       = as.numeric(lon),
            date_time = mdy_hms(date_time),
            hour      = hour(date_time),
            day       = day(date_time),
            wday      = wday(date_time, label = TRUE, abbr = FALSE),
            month     = month(date_time, label = TRUE, abbr = FALSE),
            week      = week(date_time)
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
  titlePanel("Uber Trips Interactive Dashboard (Apr–Sep 2014)"),
  sidebarLayout(
    sidebarPanel(
      selectInput("selected_months", "Select Month:",
                  choices = c("All", as.character(available_months)),
                  selected = "All"),
      conditionalPanel(
        condition = "input.tabs == 'Heatmaps'",
        selectInput("heat_type", "Heatmap Type:",
                    choices = c(
                      "Hour vs Day"   = "hour_day",
                      "Month vs Day"  = "month_day",
                      "Month vs Week" = "month_week",
                      "Base vs Day"   = "base_day"
                    ))
      ),
      conditionalPanel(condition = "input.tabs == 'Map'",
                       helpText("The map tab shows Uber trip pickup locations on a Leaflet map.")),
      conditionalPanel(condition = "input.tabs == 'Prediction'",
                       helpText("Prediction model classifies peak hours using hour and day of week."))
    ),
    mainPanel(
      tabsetPanel(id = "tabs",
                  tabPanel("Trips by Hour",         plotOutput("hour_plot")),
                  tabPanel("Trips by Hour + Month", plotOutput("hour_month_plot")),
                  tabPanel("Trips by Day",          plotOutput("day_plot"), dataTableOutput("day_table")),
                  tabPanel("Trips by Day + Month",  plotOutput("day_month_plot")),
                  tabPanel("Trips by Base + Month", plotOutput("base_month_plot")),
                  tabPanel("Heatmaps",              plotOutput("heatmap_plot")),
                  tabPanel("Map",                   leafletOutput("map", height = "600px")),
                  tabPanel("Prediction",            plotOutput("model_plot"), verbatimTextOutput("model_summary"))
      )
    )
  )
)

# --- Server ---
server <- function(input, output, session) {
  filtered_data <- reactive({
    req(input$selected_months)
    if (input$selected_months == "All") uber_data
    else uber_data %>% filter(month == input$selected_months)
  })
  
  output$hour_plot <- renderPlot({
    df <- filtered_data() %>% count(hour)
    threshold <- quantile(df$n, 0.75)
    df$peak <- df$n > threshold
    ggplot(df, aes(hour, n, fill = peak)) +
      geom_col() +
      scale_fill_manual(values = c("FALSE" = "#0073C2FF", "TRUE" = "red")) +
      labs(
        title = "Total Trips by Hour (Red = Peak Hour)",
        subtitle = "Displays hourly ride volume. Red bars indicate top 25% busiest hours.",
        x = "Hour of Day", y = "Trips"
      ) +
      theme_minimal() +
      theme(legend.position = "none")
  })
  
  output$hour_month_plot <- renderPlot({
    filtered_data() %>%
      count(month, hour) %>%
      ggplot(aes(hour, n, fill = month)) +
      geom_col(position = "dodge") +
      facet_wrap(~ month) +
      labs(
        title = "Trips by Hour for Selected Months",
        subtitle = "Each facet represents a month with trips by hour.",
        x = "Hour", y = "Trips"
      ) +
      theme_minimal()
  })
  
  output$day_plot <- renderPlot({
    filtered_data() %>%
      count(day) %>%
      ggplot(aes(day, n)) +
      geom_col(fill = "orange") +
      labs(
        title = "Trips per Day of the Month",
        subtitle = "Total Uber trips for each calendar day (1–31).",
        x = "Day", y = "Trips"
      ) +
      theme_minimal()
  })
  
  output$day_table <- renderDataTable({
    filtered_data() %>% count(day) %>% rename(Day = day, Trips = n)
  })
  
  output$day_month_plot <- renderPlot({
    filtered_data() %>%
      count(month, wday) %>%
      ggplot(aes(wday, n, fill = month)) +
      geom_col(position = "dodge") +
      labs(
        title = "Trips by Day of Week and Month",
        subtitle = "Compares day-of-week trip totals across months.",
        x = "Day of Week", y = "Trips"
      ) +
      theme_minimal()
  })
  
  output$base_month_plot <- renderPlot({
    filtered_data() %>%
      count(base, month) %>%
      ggplot(aes(base, n, fill = month)) +
      geom_col(position = "dodge") +
      labs(
        title = "Trips by Base and Month",
        subtitle = "Each bar shows total trips per base (e.g., B02512), grouped by month.",
        x = "Base", y = "Trips"
      ) +
      theme_minimal()
  })
  
  output$heatmap_plot <- renderPlot({
    data <- filtered_data()
    if (input$heat_type == "hour_day") {
      mat <- dcast(data, wday ~ hour, length)
      row_var <- "wday"
    } else if (input$heat_type == "month_day") {
      mat <- dcast(data, day ~ month, length)
      row_var <- "day"
    } else if (input$heat_type == "month_week") {
      mat <- dcast(data, week ~ month, length)
      row_var <- "week"
    } else {
      mat <- dcast(data, base ~ wday, length)
      row_var <- "base"
    }
    mat[is.na(mat)] <- 0
    mat_melt <- melt(mat, id.vars = row_var)
    ggplot(mat_melt, aes(variable, .data[[row_var]], fill = value)) +
      geom_tile(color = "white") +
      scale_fill_viridis_c() +
      labs(
        title = paste("Heatmap:", input$heat_type),
        subtitle = "Color intensity represents trip count for the selected time combination.",
        x = names(mat)[2], y = row_var, fill = "Trips"
      ) +
      theme_minimal()
  })
  
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
  
  output$model_summary <- renderPrint({
    md <- filtered_data() %>% count(hour, wday) %>% sample_n(min(20000, n()))
    md$wday <- as.numeric(factor(md$wday, levels = levels(uber_data$wday)))
    md$peak <- ifelse(md$n > quantile(md$n, 0.75), "Yes", "No")
    md$peak <- factor(md$peak)
    ctrl <- trainControl(method = "cv", number = 5)
    fit <- train(peak ~ hour + wday, data = md, method = "rpart", trControl = ctrl)
    print(fit)
  })
  
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
}

# --- Run App ---
shinyApp(ui, server)
