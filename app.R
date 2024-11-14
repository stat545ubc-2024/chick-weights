library(shiny)
library(ggplot2)
library(DT) 

# generating the UI
ui <- fluidPage(
  titlePanel("ChickWeight Dataset Viewer and Visualizer"),
  sidebarLayout(
    sidebarPanel( # creating sidebar panel for UI
      selectInput("diet_filter", "Filter by Diet:", # feature 2 input
                  choices = c("All", unique(as.character(ChickWeight$Diet))),
                  selected = "All"),
      actionButton("hist_button", "Visualize Weight as a Histogram"), # button for users to create histogram
      textOutput("num_results")  # Feature 2: Display number of results after filtering
    ),
    mainPanel( # creating main panel for UI
      DTOutput("chick_table"), 
      plotOutput("weight_histogram")
    )
  )
)

server <- function(input, output, session) {
  # Feature 1: filter dataset based on diet 
  filtered_data <- reactive({
    if (input$diet_filter == "All") {
      ChickWeight
    } else {
      ChickWeight[ChickWeight$Diet == input$diet_filter, ]
    }
  })
  
  # Feature 2: Display number of results after filtering
  output$num_results <- renderText({
    paste("Number of results:", nrow(filtered_data()))
  })
  
  # render scrollable, ordered table
  output$chick_table <- renderDT({
    datatable(filtered_data(), 
              options = list(scrollY = "400px", 
                             pageLength = 10,
                             ordering = TRUE), 
              rownames = FALSE)
  })
  
  # Feature 3: make histogram of chick weight based on filtered dataset
  observeEvent(input$hist_button, { 
    output$weight_histogram <- renderPlot({
      ggplot(filtered_data(), aes(x = weight)) +
        geom_histogram(binwidth = 10, fill = "skyblue", color = "black") +
        labs(title = "Histogram of Chick Weights",
             x = "Weight",
             y = "Frequency") +
        theme_minimal()
    })
  })
}

# run the app
shinyApp(ui = ui, server = server)

