#
# Shiny app for GEOL 590 HW8
# Rose Borden
# October 29, 2019
#

library(shiny)
library(tidyverse)

# min and max for mpg
min.mpg <- min(mtcars$mpg)
max.mpg <- max(mtcars$mpg)

# define x and y variables
axis_vars <- names(mtcars)

# Defining the UI for the app
ui <- fluidPage(

    # Application title
    titlePanel("mtcars dynamic graph"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("mpgrange",
                        "Range of mpg",
                        min = min.mpg,
                        max = max.mpg,
                        value = c(min.mpg, max.mpg)),
            # add menus to select x and y
            selectInput(inputId = "xvar",
                        label = "X axis",
                        choices = axis_vars,
                        selected = "x"),
            
            selectInput(inputId = "yvar",
                        label = "Y axis",
                        choices = axis_vars,
                        selected = "y"),
            
            # add a button to apply changes
            actionButton("go", 
                         "Go!")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("mtcars_plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  filter_mpg <- reactive({
    mtcars %>%
      filter(mpg >= min(input$mpgrange)) %>%
      filter(mpg <= max(input$mpgrange))
    })
  
  # making a plot
  p_mtcars <- eventReactive(input$go, {
    ggplot(filter_mpg(), aes_string(x = input$xvar, y = input$yvar)) +
      geom_point()
    })
  
  # Create diagnostic output window to show what kind of output the double slider creates
  output$diagnostic <- renderText(
    input$mpgrange
  )
  
  # Create a dynamic plot
  output$mtcars_plot <- renderPlot(
    p_mtcars()
  )  
}

# Run the application 
shinyApp(ui = ui, server = server)
