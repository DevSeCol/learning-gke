# install.packages("shiny")
# install.packages("shinydashboard")

library(shiny)
library(shinydashboard)
library(shinymanager)
library(leaflet)
library(RPostgreSQL)


##### authentication
# define some credentials
credentials <- data.frame(
  user = c("user", "shiny"), # mandatory
  password = c("333Collins", "12345"), # mandatory
  expire = c(NA, "2020-12-31"),
  admin = c(FALSE, TRUE),
  comment = "Simple and secure authentification mechanism 
  for single ‘Shiny’ applications.",
  stringsAsFactors = FALSE
)


##### connect to db
user <- 'postgres'
pw <- 'shiny'
host <- 'localhost' # 'shiny-db'  if deploy, otherwise: "localhost"
port <- 5431 # contain port if deployed, otherwise 5431
con<-dbConnect(dbDriver("PostgreSQL"),
               host=host, port=port, user=user,
               password=pw)
 

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
                ),
                box(
                  title = "Inputs Data", status = "warning", solidHeader = TRUE,
                  textOutput('text1'), width = 6
                ),
                box(
                  title = "histogram from db", status = "warning", solidHeader = TRUE,
                  plotOutput("plot2", height = 250), width = 6
                  # actionButton("Click_me", "Update Histogram from DB")
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
  # res_auth <- secure_server(
  #   check_credentials = check_credentials(credentials)
  # )
  
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
  
  output$text1 <- renderText({
    sample_data <- histdata[seq_len(input$slider)]
    id <- seq(from=1, to=length(sample_data))
    df <- data.frame(id, data=10*round(sample_data,2))
    
    #### write to db
    if (dbExistsTable(con, "sample_data"))
      dbRemoveTable(con, "sample_data")
    
    # Write the data frame to the database
    dbWriteTable(con, name = "sample_data", value = df, row.names = FALSE)
    
    
    sample_data
  })
  
  output$plot2 <- renderPlot({
    len <- seq_len(input$slider)
    query = 'select * from sample_data'
    # read by sql
    df_sql <- dbGetQuery(con, query)
    hist(df_sql$data)
  })
  
}


# Wrap your UI with secure_app
# ui <- secure_app(ui)
shinyApp(ui = ui, server = server)

