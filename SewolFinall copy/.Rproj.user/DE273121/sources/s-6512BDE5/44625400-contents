library(shiny) #load shiny package
library(shinydashboard)

#HEADER
header <- dashboardHeader(title = "Sewol Ferry Passenger Analysis")

#SIDEBAR
sidebar <- dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th")),
      menuItem("Source code", icon = icon("file-code-o"), 
               href = "https://github.com/rstudio/shinydashboard/")
    )
  )

#BODY
body <- dashboardBody(
    
    #TABITEMS
    tabItems(
      #First tab
      tabItem(tabName = "dashboard",
              fluidRow(
                box( 
                  plotOutput("plot", click = "plot_click")),
                box(
                  title = "Controls",
                  h4("Select:"),
                  selectInput("yaxis", "Select y-axis fill:", 
                              choices= c("Category.1","Category.2","Category.3","location","gender"))
                )
              )
      ),
      
      # Second tab 
      tabItem(tabName = "widgets",
              h2("Widgets are here!"))
      
))

#Define UI for the shiny application
shinyUI(fluidPage(
  
  dashboardPage(
    #HEADER
    header,
    #SIDEBAR,
    sidebar,
    #BODY
    body
  )
  
  
))