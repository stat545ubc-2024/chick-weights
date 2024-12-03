library(shiny)
library(ggplot2)
library(DT) 

# generating the UI
ui <- fluidPage(
  titlePanel("ChickWeight Dataset Viewer and Visualizer"),
  p("This interactive display features the ChickWeight dataset built into R. It allows you to explore the early growth of chicks in an experiment studying the effect of diet. 
     Scroll down and start exploring!"), 
  sidebarLayout(
    sidebarPanel( # creating sidebar panel for UI
      selectInput("diet_filter", "Filter by Diet (Choose a specific diet or view all):", 
                  choices = c("All", unique(as.character(ChickWeight$Diet))),
                  selected = "All"),
      sliderInput("weight_range", "Filter by Weight Range (Select minimum and maximum weights):",
                  min = min(ChickWeight$weight), max = max(ChickWeight$weight),
                  value = range(ChickWeight$weight), step = 1), # slideable filtering for ease of use
      #actionButton("hist_button", "Visualize Weight as a Histogram"),
      downloadButton("download_filtered", "Download Filtered Data (CSV)"), # allow users to download data for their own analysis
      textOutput("num_results")  # Feature 2: Display number of results after filtering
    ),
    mainPanel( # creating main panel for UI
      tags$head(tags$style(HTML(".mainPanel {
        padding: 20px;
      }"))),
      h4("Filtered Dataset Table:"), 
      DTOutput("chick_table"),
      br(),
      h4("Weight Histogram (Based on Filtered Data):"), 
      plotOutput("weight_histogram"),
      br(),
      h4("Summary Statistics (Filtered Data):"), 
      verbatimTextOutput("summary_stats") 
    )
  )
)

server <- function(input, output, session) {
  # Feature 1: filter dataset based on diet and weight range
  filtered_data <- reactive({
    data <- ChickWeight
    if (input$diet_filter != "All") {
      data <- data[data$Diet == input$diet_filter, ]
    }
    data <- data[data$weight >= input$weight_range[1] & data$weight <= input$weight_range[2], ]
    data
  })
  
  # update number of results
  output$num_results <- renderText({
    paste("Number of results:", nrow(filtered_data()))
  })
  
  # update data table
  output$chick_table <- renderDT({
    datatable(filtered_data())
  })
  
  # generate histogram
  output$weight_histogram <- renderPlot({
    ggplot(filtered_data(), aes(x = weight)) +
      geom_histogram(binwidth = 10, fill = "blue", color = "black", alpha = 0.7) +
      theme_minimal() +
      labs(title = "Weight Distribution", x = "Weight", y = "Count")
  })
  
  # download filtered data
  output$download_filtered <- downloadHandler(
    filename = function() { "filtered_chickweight.csv" },
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
  
  # summary statistics
  output$summary_stats <- renderText({
    data <- filtered_data()
    stats <- c(
      Mean = mean(data$weight, na.rm = TRUE),
      Median = median(data$weight, na.rm = TRUE),
      SD = sd(data$weight, na.rm = TRUE)
    )
    paste(names(stats), round(stats, 2), sep = ": ", collapse = "
")
  })
}

shinyApp(ui, server)