library(shiny)

# Define UI for application
shinyUI(fluidPage(title = "Request Stats",

  # Application title
  titlePanel(h1("Waze Update Request Stats", align="center")),

  # Sidebar
  sidebarLayout(
    sidebarPanel(
      #set up the panel with start and end dates to look at
       dateInput("dates1", label = h3("Start Date"), value = "2016-01-01"),
       dateInput("dates2", label = h3("End Date")),
       #which type of UR do we want to look at
       selectInput("select", label = h3("Select UR State"),
                   choices = list("Uncommented" = "UNC", "Open (Commented by Editor)" = "OP",
                                  "Open (Commented by Reporter" = "RLC"), selected = "UNC")
    ),

    # The main application Window
    mainPanel(
      tabsetPanel(
        tabPanel("Chloropleth", plotOutput("SATStates")),
        tabPanel("URs over time", plotOutput("SATStatesLine"))
      )
    )
  )
))
