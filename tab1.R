# define a list to wrap ui/server for login tab
tab_Registeration <- list() 

# define ui as tabPanel,
# so that it can be easily added to navbarPage of main shiny program
tab_Registeration$ui <- tabPanel(
  title = 'Registration', # name of the tab
  # hide the welcome message at the first place
  shinyjs::hidden(tags$div(
    id = 'tab_Registeration.welcome_div',
    class = 'Register-text', 
    textOutput('tab_Registeration.welcome_text', container = tags$h2))
  )
)

# define the ui of the login dialog box
login_dialog <- mainPanel(
  title = 'User Registration',
  
  textInput('tab_Registeration.username','Username'),
  passwordInput('tab_Registeration.password','Password'),
  actionButton('tab_Registeration.Register','Register'),
  tags$div(class = 'warn-text',textOutput('tab_Registeration.Register_msg'))
)



# define the backend of login tab
## show dialog box when stat up
## when login failed, update the warning message
## when login succeeded, remove the dialog box and show the welcome message
tab_Registeration$server <- function(input, output) {
  df = read.csv(file ="./00_tab_login/users.csv")
  df<-data.frame(df)
  # show login dialog box when initiated
  showModal(login_dialog)
  observeEvent(input$tab_login.registration, {
    tab_Registeration$server(input, output)
  })
  observeEvent(input$tab_Registeration.Register, {
    username <- input$tab_Registeration.username
    password <- input$tab_Registeration.password
    
    df[nrow(df) + 1,] = c(username,password)
    write.csv(df,"./00_tab_login/users.csv", row.names=F)
    
    output$tab_Registeration.Register_msg <- renderText('Registered')
    shinyjs::show('tab_Registeration.Register_msg')
    shinyjs::delay(1000, hide('tab_Registeration.Register_msg'))
    #removeModal()
  })
 
}