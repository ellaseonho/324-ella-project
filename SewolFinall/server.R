library(shiny)
library(datasets)
library(dplyr)
library(ggplot2)
library(tidyr)
library(leaflet)


shinyServer(
  
  function(input,output) { 
    library(ggplot2)
    
    # Import dataset name it sewol
    sewol <- read.csv("sewol.csv")
    
    # Viewing table
    View(sewol)
    # Summarise table
    summary(sewol)
    
    # Change "stokehold" to floor 1 
    sewol$floor[sewol$floor  == "stokehold"] <- "1"
    
    # Converts character into numeric:
    sewol$floor <- as.character(sewol$floor)
    
    # Convert ambiguously named attributes to more understandable names 
    sewol <- sewol %>% 
      rename(
        Passenger.Type = Category.1,
        Occupation = Category.2,
        Passenger.Type.Detail = Category.3
      )
    
    # Change several ambiguous names (misinterpretation from Korean to English) into correct form or for capitalization consistency
    sewol$Occupation <- replace(sewol$Occupation, sewol$Occupation=="task", "Worker")
    sewol$Occupation <- replace(sewol$Occupation, sewol$Occupation=="teacher", "Teacher")
    sewol$Occupation <- replace(sewol$Occupation, sewol$Occupation=="In", "Sailor")
    sewol$Occupation <- replace(sewol$Occupation, sewol$Occupation=="student", "Student")
    sewol$Occupation <- replace(sewol$Occupation, sewol$Occupation=="move", "Mover")
    sewol$Passenger.Type <- replace(sewol$Passenger.Type, sewol$Passenger.Type=="Normal", "normal")
    sewol$location <- replace(sewol$location, sewol$location=="In", "in")
    
    #---- DRAFT TRYING OUT VISUALIZATIONS (TESTING PORTION) ----#
    # Basic barchart of count of dead vs. survived
    ggplot(data = sewol) + 
      geom_bar(mapping = aes(x = Raw))
    
    ggplot(data = sewol) + 
      geom_bar(mapping = aes(x = Raw, fill =  Passenger.Type), position = "fill")
    
    ggplot(data = sewol) + 
      geom_bar(mapping = aes(x = Raw, fill =  Passenger.Type.Detail), position = "fill")
    
    # First chart of interactive portion; showing by type of passenger their survival vs. death count 
    # through a side by side chart
    ggplot(data = sewol) + 
      geom_bar(mapping = aes(x = Raw, fill =  Passenger.Type), position = "dodge")
    
    # Not used in final app, but useful in understanding which floor most students were located in 
    bar2 <- ggplot(data = sewol) + 
      geom_bar(
        mapping = aes(x = floor, fill = Raw), 
        show.legend = FALSE,
        width = 1
      ) + 
      theme(aspect.ratio = 1) +
      labs(x = NULL, y = NULL)
    bar2 + coord_flip()
    bar2 + coord_polar()
    
    #----------------DEATH RATE SUMMARY BY PASSENGER TYPE ------------------------#
    # This section is where I create a new table of data based on my "sewol" dataset, call it "sewol_tmp" and  
    # take the type of passenger (normal, sailor, or student) and calculate both their death and survival rates. 
    
    # make data frame based on the fact that there are a total of 476 passengers on the ferry, set it as tmp_data
    tmp_data <- data.frame(total1 = c(476,476,476,476,476,476))
    # make data fram of the number of people in each category, 104 normal, 33 sailors, and 339 students, set it as tmp_data2
    tmp_data2 <- data.frame(total2 = c(104,104,33,33,339,339))
    sewol_tmp <- cbind(tmp_data, tmp_data2)
    tmp_data3 <- data.frame(countd = c(33,71,10,23,261,78))
    sewol_tmp <- cbind(sewol_tmp, tmp_data3)
    
    # make the rates of each category by the total number of people in each cateogry
    sewol_tmp$rate1 <- (sewol_tmp$countd/sewol_tmp$total1)*100
    sewol_tmp$rate2 <- (sewol_tmp$countd/sewol_tmp$total2)*100
    
    #----------------------INTERACTIVE MAP VISUALIZATION------------------#
    library(tidyverse)
    library(maps)
    library(mapproj)
    library(mapdata)
    library(tmap)
    library(tmaptools)
    library(leaflet)
    
    # Import dataset of protests against government after Sewol Sinking, name variable protest
    protest <- read.csv("demostration.csv")
    
    # Make data frame, call it "korea" and save each location where protests occured and 
    # their latitudes and longitudes for each individual province of protest
    korea <- data.frame(
      name = c("Seoul", "Gwangju", "Busan","Daegu"),
      lat = c(37.5604,35.1595,35.1064,35.8714),
      lng = c(126.9800,126.8526,129.0361,128.6014),
      col = c("blue","red","blue","blue"))
    
    # Make korea into a map plot using leaflet library, adding markers to each province location with a popup of their names 
    korea <- korea %>%
      leaflet()  %>%
      addTiles()  %>%
      addMarkers(popup=korea$name)  %>%
      addLegend(labels = c("peaceful protest","protets with violence"), 
                colors = c("blue", "red"), title = "Event Type")
    
    # Add Circle Markers based on the size of the protests (number of people attending it) to visualize the size of protests
    addCircleMarkers(
      korea,
      radius = (sqrt(protest$Protestors.Number)/70),
      stroke = FALSE,
      color = "blue",
      weight = 5,
      opacity = 0.5,
      fill = TRUE,
      fillColor = "blue",
      fillOpacity = 0.2,
      options = pathOptions(),
      clusterOptions = NULL,
      clusterId = NULL,
      data = getMapData(korea)
    )
    
    #---------------------------------------------------#
    
    
    #The interactive graph showing dead vs. survived and # of people in each diff. categories
    output$plot <- renderPlot({
      ggplot(data = sewol, aes(x = Raw)) + 
        geom_bar(mapping = aes_string(fill = input$yaxis), position = "dodge")
      }, res = 96)
    
    output$plot2 <- renderPlot({
      bar2 <- ggplot(data = sewol) + 
        geom_bar(
          mapping = aes(x = Occupation, fill = Raw), 
          show.legend = FALSE,
          width = 1
        ) + 
        theme(aspect.ratio = 1) +
        labs(x = NULL, y = NULL)
      bar2 + coord_flip()
      bar2 + coord_polar()
    })
    
    # the what chart
    output$plot3 <- renderPlot({
      bar3 <- ggplot(data = sewol) + 
        geom_bar(
          mapping = aes(x = location, fill = Raw), 
          show.legend = FALSE,
          width = 1
        ) + 
        theme(aspect.ratio = 1) +
        labs(x = NULL, y = NULL)
      bar3 + coord_flip()
      bar3 + coord_polar()
    })
    
    # the survival vs death rate based on category 1 chart
    output$plot4 <- renderPlot({
      barplot(sewol_tmp$rate2,
              names.arg = c("Normal (dead)", "Normal (survive)", "Sailor (dead)", "Sailor (survive)"
                            , "Student (dead)", "Student (survive)"),
              xlab = "Type of Passenger",
              ylab = "Death Rate vs. Survival Rate",
              main = "Bar Chart of Type of Passenger and Rate of Survival vs. Death")
    })
    
    output$locplot <- renderPlot({
        ggplot(data = sewol, aes(x = Passenger.Type)) + 
          geom_bar(mapping = aes_string(fill = input$y), position = "dodge")
      }, res = 96)
    
    output$koreamap <- renderLeaflet({
      # Make data frame, call it "korea" and save each location where protests occured and 
      # their latitudes and longitudes for each individual province of protest
      korea <- data.frame(
        name = c("Seoul", "Gwangju", "Busan","Daegu"),
        lat = c(37.5604,35.1595,35.1064,35.8714),
        lng = c(126.9800,126.8526,129.0361,128.6014),
        col = c("blue","red","blue","blue"))
      
      korea <- korea %>%
        leaflet()  %>%
        addTiles()  %>%
        addMarkers(popup=korea$name)  %>%
        addLegend(labels = c("peaceful protest","protests with violence"), 
                  colors = c("blue", "red"), title = "Event Type")
      
      addCircleMarkers(
        korea,
        radius = (sqrt(protest$Protestors.Number)/70),
        stroke = FALSE,
        color = "blue",
        weight = 5,
        opacity = 0.5,
        fill = TRUE,
        fillColor = "blue",
        fillOpacity = 0.2,
        label = protest$Protestors.Number,
        options = pathOptions(),
        clusterOptions = NULL,
        clusterId = NULL,
        data = getMapData(korea)
      )
      
    })
  
  }
  
  
)
