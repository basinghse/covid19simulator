# define a list to wrap ui/server for login tab
library(shiny)
library(shinydashboard)
library(DT)
library(shinyjs)
library(sodium)
# load ui/server from each tab
source('app1.R') 
tab_login <- list() 

# define ui as tabPanel,
# so that it can be easily added to navbarPage of main shiny program
tab_login$ui <- mainPanel(id = 'tabwelcome',
  title = textOutput('tab_login.welcome_text'), # name of the tab
  # hide the welcome message at the first place
  shinyjs::hidden(
    
    tags$div(
    id = 'tab_login.welcome_div',
    class = 'login-text', top=5,
    #textOutput('tab_login.welcome_text', container = tags$h2),
      tab_01$ui
    )
  )
)

# define the ui of the login dialog box
#login_dialog <- modalDialog(
 # title = 'User Authentication',
  #footer = actionButton('tab_login.login','Login'),
  #textInput('tab_login.username','Username'),
  #passwordInput('tab_login.password','Password'),
 # tags$div(class = 'warn-text',textOutput('tab_login.login_msg'))
#)

# define the ui of the login dialog box
login_dialog <- mainPanel(
  navbarPage(
    title = 'User Authentication',
    selected = 'Login',
    tabPanel(
    #  title = 'Login', # initiate javascript
      
      # append defined ui
      
      title = 'Login',
      
      textInput('tab_login.username','Username'),
      passwordInput('tab_login.password','Password'),
      actionButton('tab_login.login','Login'),
      tags$div(class = 'warn-text',textOutput('tab_login.login_msg'))),
    tabPanel(
      #title = 'Login', # initiate javascript
      
      title = 'User Registration',
      
      textInput('tab_Registeration.username','Username'),
      passwordInput('tab_Registeration.password','Password'),
      actionButton('tab_Registeration.Register','Register'),
      tags$div(class = 'warn-text',textOutput('tab_Registeration.Register_msg'))
    ))
  )
  

db = read.csv(file ="00_tab_login/users.csv")
db<-data.frame(db)
colnames(db)[1] <- "username"
db$password=as.character(db$password)

#credentials = data.frame(
 # username= c(db$username),
#  passod   = sapply(c(db$password),password_store),
 # permission  = c("basic", "advanced"), 
#  stringsAsFactors = F
#)

# define the backend of login tab
## show dialog box when stat up
## when login failed, update the warning message
## when login succeeded, remove the dialog box and show the welcome message
tab_login$server <- function(input, output) {
  
  # show login dialog box when initiated
  showModal(login_dialog)
  
 
  # show login dialog box when initiated
  #showModal(login_dialog
  
  observeEvent(input$tab_login.login, {
    username <- input$tab_login.username
    password <- as.character(input$tab_login.password)
    #db1<-data.frame(username,password)
    if(length(which(db$username==username))==1) { 
      pasmatch  <- db["password"][which(db$username==username),]
      #pasverify <- password_verify(pasmatch, password)
      if(length(which(pasmatch==password))==1) {
        
        removeModal() # remove login dialog
       output$tab_login.welcome_text <- renderText(glue('Hello, {username}'))
        tab_01$server(input, output)
        shinyjs::show('tab_login.welcome_div') # show welcome message
        
      } else {
        # password incorrect, show the warning message
        # warning message disappear in 1 sec
        output$tab_login.login_msg <- renderText('Incorrect Password')
        shinyjs::show('tab_login.login_msg')
        shinyjs::delay(1000, hide('tab_login.login_msg'))
      }
    } else {
      # warning message disappear in 1 sec
      output$tab_login.login_msg <- renderText('Username Not Found')
      shinyjs::show('tab_login.login_msg')
      shinyjs::delay(1000, hide('tab_login.login_msg'))
    }
    
  })
  observeEvent(input$tab_Registeration.Register, {
    
    username <- input$tab_Registeration.username
    password <- input$tab_Registeration.password
    #db1<-data.frame(username,password)
    if(length(which(db$username==username))==1) { 
      # warning message disappear in 1 sec
      output$tab_Registeration.Register_msg <- renderText('this username already exist')
      shinyjs::show('tab_Registeration.Register_msg')
      shinyjs::delay(1000, hide('tab_Registeration.Register_msg'))

      
    } else {
      db[nrow(db) + 1,] = c(username,password)
      write.csv(db,"00_tab_login/users.csv", row.names=F)
      
      output$tab_Registeration.Register_msg <- renderText('Registered')
      shinyjs::show('tab_Registeration.Register_msg')
      shinyjs::delay(1000, hide('tab_Registeration.Register_msg'))
      removeModal() # remove login dialog
      #output$tabwelcome
      output$tab_login.welcome_text <- renderText(glue('Hello, {username}'))
      tab_01$server(input, output)
      shinyjs::show('tab_login.welcome_div') # show welcome message
      
    }
  })
}