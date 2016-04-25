library(shiny)

# Define UI for application
shinyUI(fluidPage(

  # Application title
  titlePanel("Waze Update Request stats"),

  # Sidebar
  sidebarLayout(
    sidebarPanel(
       sliderInput("bins",
                   "Number of bins:",
                   min = 1,
                   max = 50,
                   value = 30)
    ),

    # The main application Window
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
