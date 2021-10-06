# set up ----
library(shiny)
library(ggplot2)
library(DT)
library(palmerpenguins)

# user interface ----
ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(),
    
    mainPanel(
      
      # scatterplot (ui) ----
      plotOutput(outputId = "penguin_scatterplot"),
      
      # datatable (ui) ----
      DTOutput(outputId = "penguin_datatable")
      
    )
  )
)

# server function ----
server <- function(input, output, session) {
  
  # scatterplot ----
  output$penguin_scatterplot <- renderPlot({
    
    ggplot(data = penguins,
           aes(x = bill_length_mm, y = flipper_length_mm)) +
      geom_point()
    
  })
  
  # datatable (server) ----
  output$penguin_datatable <- renderDT({
    
    DT::datatable(penguins)
    
  })
  
}

# run Shiny app ----
shinyApp(ui, server)