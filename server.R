library(shiny)
library(plyr)
library(ggplot2)

# rds file is a pared-down version of the USA_adm files found at http://www.gadm.org/
# instead of loading the entire US every time, I created a subset of only the states
# located in the South Atlantic Waze region
# Also fortified the file so that the load wasn't placed on the server every time
# the app spins up
FortifiedSAT <- readRDS(file = "FortifiedSAT.rds")

#pull in the csv
SATURs <- read.csv(file="SAT UR Data.csv", header = TRUE)

#set the correct type for the State and Date fields so we can manipulate them later
SATURs$Date <- as.Date(SATURs$Date, "%m/%d/%Y")
SATURs$State <- as.character(SATURs$State)

# Main server function
shinyServer(function(input, output) {

  # get a subset of the pull list based on dates
  dateSubSet <- reactive({
    # Make sure time is flowing in the right direction
    validate(
      need(input$dates2 > input$dates1, "End date is earlier than start date"
      )
    )

    # Make sure greater than 14 day difference so that at least 2 measurements are available
    validate(
      need(difftime(input$dates2, input$dates1, "days") > 14, "Date range is less than 14 days"
      )
    )
    SATURs[SATURs$Date %in% input$dates1:input$dates2,]
  })



   output$SATStates <- renderPlot({
     # Gave up trying to directly use a variable in mean(), hard-coded the type
     # and used a switch instead
     switch(input$select,
            "UNC"={meanURs <- ddply(dateSubSet(), .(State), summarize, meanType = mean(Uncommented))},
            "OP"={meanURs <- ddply(dateSubSet(), .(State), summarize, meanType = mean(Open))},
            "RLC"={meanURs <- ddply(dateSubSet(), .(State), summarize, meanType = mean(RLC))}
     )
    # draw the chloropeth map using the means calculated above and the fortified map
    ggplot() + geom_map(data = meanURs,
                        aes(map_id = State, fill = meanType),
                        map = FortifiedSAT) + expand_limits(x = FortifiedSAT$long, y = FortifiedSAT$lat) +
      guides(fill=guide_legend(title="Average Requests"))
  })

   output$SATStatesLine <- renderPlot({
     ggplot(data = dateSubSet(), aes(x = Date, y = switch(input$select,"UNC"={Uncommented},"OP"={Open},"RLC"={RLC}), color = State )) +
       geom_line(aes(group = State)) +
       ylab(switch(input$select,"UNC"={"# Uncommented"},"OP"={"# Last commented by editor"},"RLC"={"# Last commented by reporter"}))
   })
})
