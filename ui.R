library(shiny)
library(shinydashboard)
library(shinythemes)
#library(shinythemes)

shinyUI(dashboardPage(skin = "yellow",
  
  dashboardHeader(title = "Chat Analysis System", dropdownMenuOutput("notify")
                  #themeSelector(),
                  ),
  
  dashboardSidebar(
    sidebarMenu(id = ('sidebarmenu'),
     menuItem(text = "Data", tabName = "data", icon = icon("file-text-o")),
     menuItem(text = "Summary", tabName = "summary", icon = icon("file-text-o")),
     menuItem(text = "About", tabName = "about", icon = icon("file-text-o") ),
     menuItem(text = "Visualization tools", tabName = "visualization"),
     menuItem("Key words",tabName = "barplot1", icon = icon("bar-chart-o")),
     menuItem("Country participation",tabName = "barplot2", icon = icon("bar-chart-o")),
     menuItem("Customercare perfomance", tabName = "customercare", icon = icon("bar-chart-o")),
     menuItem("Advertising",tabName = "advertise", icon = icon("bar-chart-o")),
     
     menuItem("Messages perHour",tabName = "ggplot", icon = icon("bar-chart-o")),
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
              box(paste("Description:This analysis tool describes the most common words in the Chat.content column of this dataset, that is;'diana' ,'akurut', which are the names of one of the system 'assistant's. We also see 'chat'and'live' which are written whenever a system assistant accepts a live chat with a customer. And others...")),
              box(paste("Prediction:It predicts that Akurut Diana should probably be promoted or be awarded employee of the month because she is noticed to be the most active system assistant.")),
              plotOutput("wordcloud")
              
              
              ),
      
      
      tabItem(tabName ="sentiment",
              plotOutput("sentiment"),
              box(paste("Description:This analysis tool gaphically describes the emotions and polarity expressed within the conversations between the customers and the system assistants.")),
              box(paste("Prediction:It predicts that there will be an increase in the usage of the system since there is alot of trust,positivity and anticipation expressed.It also predicts that the customers need to be oreinted on how to better access the services provided by the system to reduce on the negativity."))
              
              ),
      
      tabItem(tabName = "text",
              plotOutput("text")
            
              
              
        ),
      
      tabItem(tabName = "data", paste("Please select the file to be analyzed:"),
              
              fileInput("file","upload a file")
              
              ),
      
      tabItem(tabName = "summary",
              tableOutput("sum"),
              box(paste("Description:This interface gives a very summarized version of the entire dataset, column per column , showing the minimum frequency,maximum frequency, 1st quater, 3rd quater, mean and median of the variable given in that column. "))
              ),
                    
      tabItem(tabName = "about",
              paste("This is an offline system built to analyze the data generated from the day to day operations of the nssf organisation, most importantly the inteructions between the system assistants and the customers of the NSSF organizaton (the people that use the services provided by the system).
                     This includes the perfomance of the system assistants, the response of the customers about the services provided by the system.It also looks at the time when the system is most busiest. 
                  "),
              paste(""),
              
              plotOutput("about")
             
              ),
      
      tabItem(tabName ="barplot1",
              plotOutput("barPlot")
              
              
              ),
     
      
      tabItem(tabName ="barplot2",
              plotOutput("barplot")
             
              ),
      
      tabItem(tabName = "ggplot", plotOutput("emails")),
      
      tabItem(tabName = "customercare",
              plotOutput("customerCare")
              
              ),
      tabItem(tabName = "advertise",
              plotOutput("advert")
              )
      
      
      #tabItem(tabName = "scatter",
       #       plotOutput("scatterPlot"))
      
      
    )
    
  )
)
)