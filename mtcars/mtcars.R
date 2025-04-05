library(shiny)
library(ggplot2)
library(shinycssloaders) # For loading spinners

# Define UI
ui <- fluidPage(
  titlePanel("Interactive Data Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("var", 
                  "Choose a Variable:", 
                  choices = c("Miles per Gallon" = "mpg",
                              "Horsepower" = "hp",
                              "Weight (1000 lbs)" = "wt",
                              "Displacement" = "disp",
                              "Quarter Mile Time" = "qsec"),
                  selected = "mpg"),
      
      sliderInput("bins", 
                  "Number of Bins:", 
                  min = 5, 
                  max = 30, 
                  value = 15),
      
      selectInput("color", 
                  "Histogram Color:", 
                  choices = c("Blue" = "blue",
                              "Red" = "red",
                              "Green" = "green",
                              "Purple" = "purple"),
                  selected = "blue"),
      
      checkboxInput("density", 
                    "Show Density Curve", 
                    value = FALSE),
      
      hr(),
      h5("App Info"),
      p("This app visualizes the mtcars dataset."),
      p("Built with Shiny and ggplot2.")
    ),
    
    mainPanel(
      withSpinner(plotOutput("histPlot")),
      br(),
      verbatimTextOutput("stats")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Reactive expression for plot
  plot_data <- reactive({
    req(input$var) # Ensure variable is selected
    
    # Basic plot
    p <- ggplot(mtcars, aes_string(x = input$var)) +
      geom_histogram(fill = input$color, 
                     color = "black", 
                     bins = input$bins,
                     alpha = 0.8) +
      labs(title = paste("Distribution of", names(choices)[choices == input$var]),
           x = names(choices)[choices == input$var],
           y = "Count") +
      theme_minimal(base_size = 14)
    
    # Add density curve if selected
    if(input$density) {
      p <- p + geom_density(alpha = 0.2, 
                            fill = "grey20", 
                            color = "black")
    }
    
    return(p)
  })
  
  # Render plot
  output$histPlot <- renderPlot({
    plot_data()
  })
  
  # Render summary statistics
  output$stats <- renderPrint({
    req(input$var)
    cat("Summary Statistics for", names(choices)[choices == input$var], "\n\n")
    summary(mtcars[[input$var]])
  })
}

# Named vector for pretty variable names
choices <- c("Miles per Gallon" = "mpg",
             "Horsepower" = "hp",
             "Weight (1000 lbs)" = "wt",
             "Displacement" = "disp",
             "Quarter Mile Time" = "qsec")

# Run the application
shinyApp(ui = ui, server = server)