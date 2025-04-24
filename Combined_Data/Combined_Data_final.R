# Load libraries
library(shiny)
library(readxl)
library(dplyr)
library(httr)
library(janitor)
library(stringr)
library(ggplot2)
library(hms)
library(lubridate)

# Clear environment
rm(list = ls())

# ===== Read Excel from GitHub =====
url <- "https://github.com/nabindrak7/Naby_DATA332/raw/f2165ac425888bbf7f4a2f22ca3acde66b0562e4/Combined_Data/Combined_Data.xlsx"
temp <- tempfile(fileext = ".xlsx")
GET(url, write_disk(temp, overwrite = TRUE))
raw_data <- read_excel(temp)

# ===== Clean and Prepare Data =====
all_data <- raw_data %>%
  clean_names() %>%
  rename_with(str_to_title) %>%
  rename(
    Time = matches("Time", ignore.case = TRUE),
    Speed = matches("Speed", ignore.case = TRUE),
    VehicleType = matches("Vehicle|Car|Type", ignore.case = TRUE),
    Student = matches("Student", ignore.case = TRUE)
  ) %>%
  mutate(
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
      str_detect(Time, "^\\d{1,2}:\\d{2}$") ~ paste0(Time, ":00"),
      str_detect(Time, "^\\d{1,2}:\\d{2}[APap][Mm]$") ~ format(strptime(Time, "%I:%M%p"), "%H:%M:%S"),
      TRUE ~ Time
    ),
    Time = suppressWarnings(as_hms(Time))
  ) %>%
  filter(!is.na(Student))

# ===== UI =====
ui <- fluidPage(
  titlePanel("Vehicle Speed Dashboard (Time in 24hr HH:MM)"),
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
        tabPanel("Data Table", tableOutput("data_table"))
      )
    )
  )
)

# ===== Server =====
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
      labs(title = "Speed Compliance by Student", y = "Vehicle Count", x = "Student") +
      theme_minimal()
  })
  
  # Chart 2: Avg Speed by Vehicle Type
  output$vehicle_type_chart <- renderPlot({
    filtered_data() %>%
      filter(!is.na(Speed), !is.na(VehicleType)) %>%
      group_by(VehicleType) %>%
      summarise(AverageSpeed = mean(Speed), .groups = "drop") %>%
      ggplot(aes(x = reorder(VehicleType, -AverageSpeed), y = AverageSpeed)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Average Speed by Vehicle Type", x = "Vehicle Type", y = "Average Speed (mph)") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, face = "bold"))
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
  
  # Table: format Time to HH:MM
  output$data_table <- renderTable({
    filtered_data() %>%
      mutate(Time = format(Time, "%H:%M"))
  })
}

# ===== Run App =====
shinyApp(ui = ui, server = server)
