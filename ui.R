library(shiny)
library(shinydashboard)

shinyUI(
  dashboardPage(
    dashboardHeader(title = "NSSF CHAT ANALYSIS SYSTEM"),
    dashboardSidebar(
      menuItem("DASHBOARD"),
      menuItem("COMPANY EXECUTIVES"),
      menuItem("MARKETING STAFF"),
      menuItem("DATA ANALYSTS"),
      menuItem("SYSTEM ADMINISTRATOR"),
      menuItem("RAW DATA")
      
      
    ),
    
dashboardBody()
)
)
  
