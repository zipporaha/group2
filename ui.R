library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(skin = "green",
  
  dashboardHeader(title = "Chat Analysis System", titleWidth = 500),
  
  dashboardSidebar(
    sidebarMenu(id = ('sidebarmenu'),
      
     menuItem(text = "About", tabName = "about" ),
     menuItem(text = "Data", tabName = "data"),
     fileInput("file","upload a file"),
    
     menuItem(text = "Visualization tools", tabName = "visualization"),
     menuItem("Bar-plot1",tabName = "barplot1", icon = icon("bar-chart-o")),
     menuItem("Bar-plot2",tabName = "barplot2", icon = icon("bar-chart-o")),
    
     menuItem("Scatter-plot",tabName = "scatter"),
     menuItem("Histogram",tabName = "histogram", icon = icon("bar-chart-o")),
     menuItem("Bar-chat",tabName = "barchat", icon = icon("bar-chart-o")),
     menuItem(text = "Analysis tools", tabName = "analysis"),
     menuItem(text = "Wordcloud", tabName = "wordcloud", icon = icon("cloud")),
     
     
     menuItem("SentimentAnalysis", tabName = "sentiment", icon = icon("bar-chart-o")),
     menuItem("TextAnalysis", tabName = "text", icon = icon("bar-chart-o"))
     )
  ),
  
  dashboardBody(
    
    tabItems(
      
      tabItem(tabName = "wordcloud", 
              box(
                sliderInput("wd", "Minimum frequency of words",0 ,20, 10),
                sliderInput("wcloud", "Maximum number of words",0 ,500, 100)
              ),
              plotOutput("wordcloud"),
              radioButtons(inputId = "radio", label = "Select the file type", choices =list( "png","pdf")),
              downloadButton(outputId = "down", label = "Download file")
              
              ),
      
      
      tabItem(tabName ="sentiment",
              plotOutput("sentiment")
              ),
      
      tabItem(tabName = "text",
              plotOutput("text")
              
        ),
      
      tabItem(tabName = "about",
              plotOutput("about"),
              paste("
              Chat Analysis System for NSSF Organisation.
    This system is an offline system built to;
    1. enable NSSF executives make more precise decission concerning the 
                    
                    
                    ")
              ),
      
      tabItem(tabName ="barplot1",
              plotOutput("barPlot")),
     
      
      tabItem(tabName ="barplot2",
              plotOutput("barplot")),
      
      tabItem(tabName = "scatter",
              plotOutput("scatterPlot"))
      
      
    )
    
  )
)
)