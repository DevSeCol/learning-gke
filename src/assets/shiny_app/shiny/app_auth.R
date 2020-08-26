# install.packages("shiny")
# install.packages("shinydashboard")

user_name=Sys.getenv('SHINYUSERNAME')
pw=Sys.getenv('SHINYPASSWORD')

library(shiny)
library(shinydashboard)
library(shinymanager)
# library(leaflet)
# library(RPostgreSQL)


##### authentication
# define some credentials
credentials <- data.frame(
  user = c(user_name, "xiaoxi"), # mandatory
  password = c(pw, "RShiny"), # mandatory
  expire = c('2020-12-31', NA),
  admin = c(FALSE, TRUE),
  comment = "Simple and secure authentification mechanism 
  for single ‘Shiny’ applications.",
  stringsAsFactors = FALSE
)


###### classic app
ui <- dashboardPage(
  dashboardHeader(title = "Shiny dashboard-80"),
  
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "basicdashboard", icon = icon("dashboard")),
      menuItem("Map", tabName = "map", icon = icon("th"))
    )
  ),
  
  
  ## Body content
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "basicdashboard",
              fluidRow(
                box(
                  title = "Histogram", status = "primary", solidHeader = TRUE,
                  collapsible = TRUE, width = 8,
                  plotOutput("plot1", height = 250)
                  ),
                
                box(
                  title = "Inputs", status = "warning", solidHeader = TRUE, width = 4,
                  "1. Generate sample data", br(),
                  "2. plot in histogram", br(),
                  "3. export to postgress with rounding",
                  sliderInput("slider", "Number of observations:", 1, 100, 50),
                  submitButton("Submit")
                )
              )
      ),
      
      # Second tab content
      tabItem(tabName = "map",
              fluidRow(
                box(
                  title = "Title 1", width = 9, solidHeader = TRUE, status = "primary",
                  "Map"
                ),

                box(
                  title = "Title 2", width = 3, solidHeader = TRUE, status = "primary",
                  "Map input"
                )
              ),

              fluidRow(
                box(
                  title = "Title", width = 4, solidHeader = TRUE, status = "primary",
                  "Chart-1"
                ),
                box(
                  title = "Title", width = 4, solidHeader = TRUE, status = "primary",
                  "Chart-2"
                ),
                box(
                  title = "Title", width = 4, solidHeader = TRUE, status = "primary",
                  "Chart-3"
                )
        )
      )
    )
  )
)




# Define server logic  
server <- function(input, output, session) {
  # check_credentials returns a function to authenticate users
  res_auth <- secure_server(
    check_credentials = check_credentials(credentials)
  )

  # output$auth_output <- renderPrint({
  #   reactiveValuesToList(res_auth)
  # })
  
  # your classic server logic
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  

  
}


# Wrap your UI with secure_app
ui <- secure_app(ui)
shinyApp(ui = ui, server = server)

