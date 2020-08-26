library(shiny)
library(shinydashboard)
library(shinymanager)
library(leaflet)
library(RPostgreSQL)

setwd("~/Documents/project/learning/docker/test-xiaoxi/src/assets/shiny_app")
getwd()
# runApp("shiny/auth_app_local.R", host = '0.0.0.0', port=80)

runApp("shiny/app_auth.R", host = '0.0.0.0', port=80)
