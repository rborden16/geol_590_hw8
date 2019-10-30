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
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
