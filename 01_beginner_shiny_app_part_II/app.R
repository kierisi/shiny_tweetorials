# set up ----
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(palmerpenguins)

# user interface ----
ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      
      # filter scatterplot and data table by species----
      checkboxGroupInput(inputId = "penguin_species",
                         label = "Filter by species: ",
                         choices = c("Adelie", "Chinstrap", "Gentoo"),
                         selected = c("Adelie", "Chinstrap", "Gentoo")),
      
      # color scatterplot points ----
      selectInput(inputId = "scatterplot_color",
                  label = "Color points by:",
                  choices = c("species", "island", "sex")), 
      
      # select scatterplot point size ----
      sliderInput(inputId = "point_size",
                  label = "Select a point size: ",
                  min = 1, max = 10, value = 5),
      
      # change the alpha value of scatterplot points ----
      sliderInput(inputId = "point_alpha",
                  label = "Select an alpha value: ",
                  min = 0, max = 1, value = 0.8, 
                  step = 0.1),
      
      # select x-axis value for scatterplot ----
      selectInput(inputId = "x_axis",
                  label = "Select a value for the x-axis: ",
                  choices = c("bill_length_mm", "bill_depth_mm",
                              "flipper_length_mm", "body_mass_g", "year"),
                  selected = "bill_length_mm"),
      
      # select y-axis value for scatterplot ----
      selectInput(inputId = "y_axis",
                  label = "Select a value for the y-axis: ",
                  choices = c("bill_length_mm", "bill_depth_mm",
                              "flipper_length_mm", "body_mass_g", "year"),
                  selected = "flipper_length_mm")
    ),
    
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
  
  # reactive function for penguin species ----
  filtered_penguins <- reactive({
    penguins %>% filter(species %in% input$penguin_species)
  })
  
  # scatterplot ----
  output$penguin_scatterplot <- renderPlot({

    ggplot(data = filtered_penguins(),
           aes_string(x = input$x_axis, y = input$y_axis)) +
      geom_point(aes_string(color = input$scatterplot_color),
                 size = input$point_size,
                 alpha = input$point_alpha)

  })
  

  
  # datatable (server) ----
  output$penguin_datatable <- renderDT({
    
    DT::datatable(filtered_penguins())
    
  })
  
}

# run Shiny app ----
shinyApp(ui, server)


