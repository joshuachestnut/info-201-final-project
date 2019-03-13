library("ggplot2") # load ggplot
library("shiny") # load shiny
library("dplyr") # load dplyr

source("final_ui.R") # source ui
source("final_server.R") # source server

shinyApp(ui = final_ui, server = final_server) # create shinyApp
