library(shiny)
library(datasets)
library(dplyr)
library(ggplot2)

shinyServer(
  function(input,output) { 
      
    #The interactive graph showing dead vs. survived and # of people in each diff. categories
    output$plot <- renderPlot({
      ggplot(data = sewol, aes(x = Raw)) + 
        geom_bar(mapping = aes_string(fill = input$yaxis), position = "dodge")
      }, res = 96)
    
  
  }
)
