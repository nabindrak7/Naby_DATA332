# Load libraries
library(shiny)
library(readxl)
library(readr)
library(dplyr)
library(httr)
library(janitor)
library(stringr)
library(ggplot2)
library(hms)
library(lubridate)

# Clear environment
rm(list = ls())

# Dataset info
datasets_info <- list(
  list(url = "https://github.com/rohaanfarrukh/data332_counting_cars/raw/c98fe69374ccdd9f852c9a48f2cfe9c5f28ca870/counting_cars_project/rscript/speed_counting_cars.xlsx", student = "Rohaan"),
  list(url = "https://github.com/TommyAnderson/Car-Data-Analysis/raw/7cd2a7a515e85385854273698753b99ae24e67ac/Car%20Data%20Collection.csv", student = "Tommy"),
  list(url = "https://github.com/nickhc41703/Data_332_assignments/raw/c8c64c1f825f76b7b28e8ea327fa872491d1c73e/Homework/counting_cars/counting_cars_final.csv", student = "Nick"),
  list(url = "https://github.com/kritansth/data332/raw/5916d3252330aa96531f28555ea72956202790fc/counting_cars/cars_count.xlsx", student = "Kritan"),
  list(url = "https://github.com/retflipper/DATA332_CountingCars/raw/3a30ac4d28aee949c7a01fb0f9d11a70b937bd48/data/Counting_Cars.csv", student = "Retflipper"),
  list(url = "https://github.com/nissou62/The-very-basics-of-R/raw/6393e669b2745bb516fc916288c3afe8a48980d4/shinymtcar_project/Data_Counting_Cars.csv", student = "Nissou"),
  list(url = "https://github.com/1R0NCL4D-B4ST10N/DATA332/raw/361329a6e87b930e66e87f20f2d137f2f0810a46/carTracker/carTracker.xlsx", student = "Ironclad"),
  list(url = "https://github.com/nabindrak7/Naby_DATA332/raw/156a468cd26ce3a6f693e045001986970a31127b/CountingCars/Vehicle_data.csv", student = "Nabindra")
)

# File readers
read_xlsx_url <- function(url) {
  tmp <- tempfile(fileext = ".xlsx")
  GET(url, write_disk(tmp, overwrite = TRUE))
  read_excel(tmp)
}
read_csv_url <- function(url) {
  read_csv(url, show_col_types = FALSE)
}

# Wrangling function (includes all vehicle types)
wrangle_dataset <- function(url, student) {
  df <- if (grepl("\\.xlsx$", url)) read_xlsx_url(url) else read_csv_url(url)
  df <- clean_names(df)
  
  time_col <- names(df)[str_detect(names(df), "time")]
  speed_col <- names(df)[str_detect(names(df), "speed|mph|initial")]
  vehicle_col <- names(df)[str_detect(names(df), "vehicle|car|type")]
  
  if (length(time_col) == 0) { df$time_placeholder <- NA; time_col <- "time_placeholder" }
  if (length(speed_col) == 0) { df$speed_placeholder <- NA; speed_col <- "speed_placeholder" }
  if (length(vehicle_col) == 0) { df$vehicle_type <- NA; vehicle_col <- "vehicle_type" }
  
  df_cleaned <- df %>%
    select(Time = all_of(time_col[1]),
           Speed = all_of(speed_col[1]),
           VehicleType = all_of(vehicle_col[1])) %>%
    mutate(
      Student = student,
      Speed = as.numeric(Speed),
      VehicleType = str_to_title(trimws(as.character(VehicleType))),
      VehicleType = case_when(
        str_detect(VehicleType, "Suv") ~ "SUV",
        str_detect(VehicleType, "Pickup|Truck") ~ "Truck",
        str_detect(VehicleType, "Van") ~ "Van",
        str_detect(VehicleType, "Motorcycle") ~ "Motorcycle",
        str_detect(VehicleType, "Sedan") ~ "Sedan",
        TRUE ~ VehicleType
      ),
      Time = as.character(Time),
      Time = case_when(
        is.na(Time) ~ NA_character_,
        str_detect(Time, "^\\d{1,2}:\\d{2}:\\d{2}$") ~ Time,
        str_detect(Time, "^\\d{1,2}:\\d{2}$") ~ paste0(Time, ":00"),
        str_detect(Time, "^\\d{1,2}:\\d{2}[AP]M$") ~ format(strptime(Time, "%I:%M%p"), "%H:%M:%S"),
        TRUE ~ NA_character_
      ),
      Time = suppressWarnings(parse_time(Time))
    )
  
  return(df_cleaned)
}

# Combine all datasets
all_data <- bind_rows(lapply(datasets_info, function(info) {
  tryCatch({
    wrangle_dataset(info$url, info$student)
  }, error = function(e) {
    message(paste("Error in", info$student, ":", e$message))
    NULL
  })
})) %>% filter(!is.na(Student))

# UI
ui <- fluidPage(
  titlePanel("Vehicle Speed Analysis Dashboard (Speed Limit: 30 mph)"),
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("selected_students", "Select Students:",
                         choices = unique(all_data$Student),
                         selected = unique(all_data$Student))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Speed Compliance", plotOutput("bar_chart")),
        tabPanel("Avg Speed by Vehicle Type", plotOutput("vehicle_type_chart")),
        tabPanel("Avg Speed Over Time", plotOutput("line_chart")),
        tabPanel("Full Data Table", tableOutput("data_table"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  filtered_data <- reactive({
    all_data %>% filter(Student %in% input$selected_students)
  })
  
  # Chart 1: Speed Compliance
  output$bar_chart <- renderPlot({
    filtered_data() %>%
      mutate(SpeedCategory = ifelse(Speed > 30, "Over Limit", "Within Limit")) %>%
      group_by(Student, SpeedCategory) %>%
      summarise(Count = n(), .groups = "drop") %>%
      ggplot(aes(x = Student, y = Count, fill = SpeedCategory)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Speed Compliance by Student", y = "Vehicle Count") +
      theme_minimal()
  })
  
  # Chart 2: Avg Speed by Vehicle Type (vertical bold labels)
  output$vehicle_type_chart <- renderPlot({
    filtered_data() %>%
      filter(!is.na(Speed), !is.na(VehicleType)) %>%
      group_by(VehicleType) %>%
      summarise(AverageSpeed = mean(Speed), .groups = "drop") %>%
      ggplot(aes(x = reorder(VehicleType, -AverageSpeed), y = AverageSpeed)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Average Speed by Vehicle Type", x = "Vehicle Type", y = "Average Speed (mph)") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, face = "bold"))
  })
  
  # Chart 3: Avg Speed Over Time
  output$line_chart <- renderPlot({
    filtered_data() %>%
      filter(!is.na(Time), !is.na(Speed)) %>%
      mutate(TimeHour = hour(Time) + minute(Time) / 60) %>%
      group_by(TimeHour) %>%
      summarise(AvgSpeed = mean(Speed), .groups = "drop") %>%
      ggplot(aes(x = TimeHour, y = AvgSpeed)) +
      geom_line(color = "darkred", size = 1.2) +
      geom_point() +
      labs(title = "Average Speed by Time of Day", x = "Hour", y = "Average Speed (mph)") +
      theme_minimal()
  })
  
  # Data Table
  output$data_table <- renderTable({
    filtered_data()
  })
}

# Launch the app
shinyApp(ui = ui, server = server)
