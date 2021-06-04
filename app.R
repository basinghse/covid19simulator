rm(list = ls())
gc()

library(shiny)
library(shinyjs)
library(glue)

# load global parameters (DB connections, login credentials, etc)
#source('global.R') 

# load ui/server from each tab
#source('tab.R') 

source('app1.R')

app.title <- 'Real Time Simulation And Risk Assessment of Covid-19 Data'
source('tab.R') # load tab_login ui/server
#source('tab1.R')

ui <- navbarPage(
  title = 'Real Time Simulation And Risk Assessment of Covid-19 Data',
  selected = 'Login',
  useShinyjs(), # initiate javascript
  
  tab_login$ui # append defined ui
  
)

server <- tab_login$server # assigned defined server

shinyApp(ui = ui, server = server)
