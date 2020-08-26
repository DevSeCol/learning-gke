# install.packages('RPostgreSQL')
library(RPostgreSQL)

# connect to db
user <- 'postgres'
pw <- 'shiny'
con<-dbConnect(dbDriver("PostgreSQL"), 
               host="localhost", port=5432, user=user,
               password=pw)

dbListTables(con)

query = 'select * from table_r'

# read by sql
df <- dbGetQuery(con, query)
df

# read all rows
dbReadTable(con, "table_r")

# disconnect from the database
dbDisconnect(con)


### write
set.seed(122)
histdata <- rnorm(500)
id <- seq(from=1, to=length(sample_data))
df <- data.frame(id, data=round(sample_data,2))

if (dbExistsTable(con, "sample_data"))
  dbRemoveTable(con, "sample_data")

# Write the data frame to the database
dbWriteTable(con, name = "sample_data", value = df, row.names = FALSE)
