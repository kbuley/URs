library(shiny)
library(plyr)
#library(rgeos)
#library(maptools)
library(ggplot2)
FortifiedSAT <- readRDS(file = "FortifiedSAT.rds")
SATURs <- read.csv(file="SAT UR Data.csv", header = TRUE)
SATURs$Date <- as.Date(SATURs$Date, "%m/%d/%Y")
SATURs$State <- as.character(SATURs$State)

# Main server function
shinyServer(function(input, output) {

   output$SATStates <- renderPlot({
    dateSubSet <- SATURs[SATURs$Date %in% input$dates1:input$dates2,]
    switch(input$select,
           "UNC"={meanURs <- ddply(dateSubSet, .(State), summarize, meanType = mean(Uncommented))},
           "OP"={meanURs <- ddply(dateSubSet, .(State), summarize, meanType = mean(Open))},
           "RLC"={meanURs <- ddply(dateSubSet, .(State), summarize, meanType = mean(RLC))}
    )

    ggplot() + geom_map(data = meanURs,
                        aes(map_id = State, fill = meanType),
                        map = FortifiedSAT) + expand_limits(x = FortifiedSAT$long, y = FortifiedSAT$lat)
  })
})
