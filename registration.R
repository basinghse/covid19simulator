library(shiny)
library(shinyjs)
library(glue)

source('tab1.R') # load tab_login ui/server

ui <- bootstrapPage(
  tags$h4("User Registration Page"),
  #title = 'registration',
  #selected = 'Registration',
  useShinyjs(), # initiate javascript
  tab_Registeration$ui # append defined ui
)

server <- tab_Registeration$server # assigne defined server

shinyApp(ui = ui, server = server)
