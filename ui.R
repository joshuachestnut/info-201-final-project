library("dplyr")
library("ggplot2")
library("shiny")
library("rsconnect")

setwd("~/Desktop/info-201-final-project")
fertility_data_one <- read.csv("data/fertility_data_one.csv", stringsAsFactors = FALSE)
fertility_data_two <- read.csv("data/fertility_data_two.csv", stringsAsFactors = FALSE)

fertility_data_complete <- merge(fertility_data_one, fertility_data_two) %>%
  select(Entity, Year, fertility_rate, gdp_per_capita)

year_range <- range(fertility_data_complete$Year)

my_ui <- fluidPage(
  
  # Give the UI a Title
  titlePanel("Correlation Between Forest Area and Selected Feature"),
  
  # Add a sidebarLayout
  sidebarLayout(
    
    # Add a sidebarPanel within the sidebarLayout
    sidebarPanel(
      sliderInput("Year", "Select Years of Interest:", min = year_range[1], max = year_range[2], value = year_range),
      # This is a selectInput to select the country of interest.
      selectInput("Country", "Select Country of Interest", choices = fertility_data_complete$Entity, selected = "", selectize = TRUE)
    ),
    # Add the mainPanel to the fluid page.
    mainPanel(
      # In order to create tabs on the fluid page, add the tabsetPanel
      tabsetPanel(
        # This is the tabPanel for the data table.
        tabPanel("Data Table", tableOutput("dataTable"), textOutput("tableText")),
        # This is the tabPanel for the Correlation Plot.
        tabPanel("Correlation Plot", plotOutput("correlationPlot"), textOutput("plotText"))
      )
    )
  )
)




