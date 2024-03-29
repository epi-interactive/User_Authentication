##################################
# Created by Epi-interactive
# 18 May 2019
# https://www.epi-interactive.com
##################################

library(shiny)
library(bcrypt)

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css")
  ),
  uiOutput("mainUI")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # The expected username and password are admin/admin
  # The long password string in the following variable is generated by hashpw("admin")
  credentials <- reactiveValues(userIsAuth = FALSE, username = "admin",
                                password = "$2a$12$jxoOXWVRB0XPJzfyViVjY.NkgqZlCcW4UbnOjRPvppH0ENRlH8s3y")
  
  observeEvent(input$loginbtn, {
    if(input$username == credentials$username)
    {
      credentials$userIsAuth <- checkpw(input$password, credentials$password)
    }
    else
    {
      showModal(modalDialog(
        title = "Error",
        "Incorrect username or password. please try again! (Hint: admin/admin)"
      ))
    }
  })
  
  output$mainUI <- renderUI({
    if(credentials$userIsAuth){
      tagList(
        titlePanel("Old Faithful Geyser Data"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
          uiOutput("sliderInput"),
          
          # Show a plot of the generated distribution
          mainPanel(
            plotOutput("distPlot")
          )
        )
      )
    }else{
      #Display the login screen 
      div(class="login-wrapper", 
        div(class="login",
           h1("User Authentication"),
           hr(),
           textInput("username", "Username:"),
           passwordInput("password", "Password:"),
           fluidRow(
             actionButton("loginbtn", "Login", class = "btn-primary full-width")
           ),
           fluidRow(
             tags$img(src="images/Epi_Logo.png", width= "300px")
           )
        )
      )
    }
  })
  
  output$sliderInput <- renderUI({
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    )
  })
  
  output$distPlot <- renderPlot({
    req(input$bins)
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
   
}

# Run the application 
shinyApp(ui = ui, server = server)

