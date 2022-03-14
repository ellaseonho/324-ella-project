library(shiny) #load shiny package
library(shinydashboard)
library(leaflet)

# Import dataset name it sewol
sewol <- read.csv("sewol.csv")

#HEADER
header <- dashboardHeader(title = "Analyzing the Sinking of MV Sewol Ferry",
                          titleWidth = 400)

#SIDEBAR
sidebar <- dashboardSidebar(
  #--------------------BY SUBMENU ITEMS------------------#
    sidebarMenu(
      menuItem("About the Incident", tabName = "about", icon = icon("list-alt")),
      menuItem("CHARTS", tabName = "dashboard", icon = icon("bar-chart-o"), startExpanded = "FALSE",
      menuSubItem("Interactive Barplot", tabName = "interactive"),
      menuSubItem("Polar Plot", tabName = "subitem2"),
      menuSubItem("Survival Rate", tabName = "subitem3"),
      menuSubItem("Protests Map", tabName = "map")
      ),
      menuItem("Source code", icon = icon("file-code-o"), 
               href = "https://github.com/rstudio/shinydashboard/"))
  )


#BODY
body <- dashboardBody(
  tags$head(tags$style(HTML('
                                /* body */
                                .content-wrapper, .right-side {
                                background-color: #ffffff;
                                }'))),
                                
                            
  #---------------------DIVIDED BY TAB ITEMS------------------#
  tabItems(
      
      # Intro tab
      
      tabItem(tabName = "about",
              HTML(
                paste( h1(strong("SINKING OF SEWOL-HO:"), style = "font-size:80px;"),
              h1(strong("A TRAGEDY THAT TRAUMATISED A GENERATION"),style = "font-size:55px;"),
              HTML(
                paste(
                  img(src= "http://newsimg.hankookilbo.com/2017/04/01/201704011116469958_2.jpg", height = "70%", width = "70%", ),
                  h2(strong("April 16, 2014.")),
                  h4("The disaster of the Sewol-Ho (Sewol Ferry) which took place on April 16th, 2014, was one of the
                     worst maritme disasters in South Korea in decades, rescuing only 172 out of 476 people."),
                  h4("
The walls of the ferry they are riding, the Sewol-ho (Sewol Ferry), are leaning at a distressing angle. But the scene is surprisingly calm. No one is running or shouting—the group is patiently waiting for further instructions from the intercom, which has just told passengers to stay where they are."),
                  h3("But only the people who didn’t follow the order survived."),
                  img(src = "https://image.news1.kr/system/photos/2019/4/16/3601294/article.jpg/dims/optimize", height = "28%", width = "28%", align = "right"),
                  h4("When Sewol-ho departed, she was carrying 476 passengers, 33 crew members. Among the 476 passengers were 339 students on a field trip from Danwon High School. To date, it is known as the largest accident for the first time in decades in South Korea, leaving 304 people dead and missing.
"),
                  h4("The sinking of Sewol-ho resulted in widespread social and political reaction within South Korea. Many criticized the actions of the ferry's captain and most of the crew. Also criticized was the administration of President Park for her response to the disaster, not seeming to know what was going on, even 17 hours after the sinking, and the government for prioritizing public image over the lives of its citizens in refusing help from other countries and publicly downplaying the severity of the disaster.
"),
                  h4("On 15 May 2014, the captain and three crew members were charged with murder, while the other eleven members of the crew were indicted for abandoning the ship. "),
                  h3("April 16, 2022 marks the 8th anniversary of the disaster and the 8th anniversary of the victims."),
                  img(src = "https://pbs.twimg.com/media/EzBj7EoVIAIfYiY.jpg", height = "30%", width = "20%", style="display: block; margin-left: auto; margin-right: auto;")))
                )
              )
              ),
      
      #----------------------INTERACTIVE BARCHART VISUALIZATIONS------------------#
      tabItem(tabName = "interactive",
              fluidRow(
                box(
                  title = "Location of Passengers by Type", background = "red",
                  plotOutput("locplot", click = "plot_click")),
                box (
                  title = "Controls #2", background = "red",
                  selectInput("y", "Select y-axis to view by:",
                              choices = c("floor", "location")
                  )
                )),
              HTML(
                paste(
                  h4("Investigating what possibilities led to the substantial death rate of students, there were few significant correlations. Firstly, checking the first interactive bar chart (red) lets us know most students were located on the fourth floor of the ferry. This contradicts most people's initial intuition that, since the fourth floor is the higher floors on the ship, they would have more time to survive or get out of the ship. This showcases the first point of anger in citizens: they had time and potential to all survive as long as the adults had taken the responsible actions for their lives.
")
                )),
              fluidRow(
                box(
                  title = "Interactive Bar Charts", background = "blue",
                  plotOutput("plot", click = "plot_click")),
                box(
                  title = "Controls", background = "blue",
                  selectInput("yaxis", "Select Category to view by:", 
                              choices= c("Passenger.Type","Occupation","location","gender"))                )
              )
      ),
      
      #---------------------POLAR PLOT VISUALIZATION------------------#
      tabItem(tabName = "subitem2",
              fluidRow(
                box(
                  title = "Passenger Occupation vs. Survival/Death Count", background = "black",
                  plotOutput("plot2", click = "plot_click")),
                
                box(
                  title = "Location vs. Survival/Death Count", background = "blue",
                  plotOutput("plot3", click = "plot_click"))
                )
              ),
      
      #-----------------BY RATE OF SURVIVAL VS. DEATH ON TYPE OF PASSENGER VISUALIZATION------------------#
      tabItem(tabName = "subitem3",
              fluidRow(
                  plotOutput("plot4", click = "plot_click",width = "90%"))
      ),
      
      
      #----------------------INTERACTIVE MAP VISUALIZATION------------------#
      tabItem(tabName = "map",
              fluidRow(
                box(
                  title = "Interactive Map Chart", background = "red",
                  leafletOutput("koreamap")
                )
              ))
      
))

#Define UI for the shiny application
shinyUI(fluidPage(
  
  dashboardPage(skin = "black",
    #HEADER
    header,
    #SIDEBAR,
    sidebar,
    #BODY
    body
    )
  
  
))