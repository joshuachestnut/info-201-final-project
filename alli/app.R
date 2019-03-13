library(shiny)
library(dplyr)
library(ggplot2)
library(maps)
install.packages("tidyquant")

# Loads the fertility data set
data <- read.csv("fertility_data_set_one.csv", fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)

my_ui <- fluidPage(
  # Application title
  titlePanel("Life Expectancy"),
  
  countries <- as.character(data[[1]]),
  
  # Sidebar with a selection input for number of bins 
  sidebarPanel(
    selectInput("country1", "Country:", countries),
    selectInput("country2", "Country:", countries)
  ),
  
  # Main panel to show table and data visualization
  mainPanel(
    fluidRow(
      column(width = 6,
             plotOutput("plot1")),
      column(width = 6,
             plotOutput("plot2"))
    )
  )
)

my_server <- function(input, output) {
  avg_life <- data %>%
    filter(life_expectancy != "NA") %>%
    select(
      year, life_expectancy, country
    ) %>% 
    group_by(year) %>% 
    mutate(
      avg = mean(life_expectancy)
    ) %>% 
    distinct()
  
  output$plot1 <- renderPlot({
    country_frame <- avg_life %>%
      filter(country == input$country1)
    
    ggplot(country_frame, aes(year)) +                    
      geom_point(aes(y = life_expectancy), colour = "blue") + 
      geom_point(aes(y = avg), colour = "green") + 
      labs(
        title = paste("Avg Overall Life Expectancy vs", paste(input$country1, "Life Expectancy"))
      )
  })
  
  output$plot2 <- renderPlot({
    country_frame <- avg_life %>%
      filter(country == input$country2)
    
    ggplot(country_frame, aes(year)) +                    
      geom_point(aes(y = life_expectancy), colour = "blue") + 
      geom_point(aes(y = avg), colour = "green") +
      labs(
        title = paste("Avg Overall Life Expectancy vs", paste(input$country2, "Life Expectancy"))
      )
  })

}

# Run the application 
shinyApp(ui = my_ui, server = my_server)
