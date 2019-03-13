library(shiny)
library(dplyr)
library(ggplot2)

# Loads the fertility data set
data <- read.csv("fertility_data_set_one.csv", fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)
countries <- as.character(data[[1]])

my_ui <- fluidPage(
  # Application title
  titlePanel("Life Expectancy"),
  
  
  
  # Sidebar with a selection input for number of bins 
  sidebarPanel(
    p("Select two different countries to see how their life expectancies compare."),
    selectInput("country1", "Country 1:", countries, "Afghanistan"),
    selectInput("country2", "Country 2:", countries, "Japan"),
    p("This visualization answers question 3: 
      What was the average life expectancy for all countries (combined) in 1960? 
      How does that value compare to the average life expectancy for all countries in 2016? 
      Has the average life expectancy for all countries increased, decreased, or stayed relatively 
      the same over the years? The blue represents the first selected country, the red
      represents the second, and the grey represents the overall average life expectancy of all countries combined. The comparison of different
      country's life expectancies through different colors reveals how life expectancy has changed
      over the years. Overall, almost all countries have experienced an increase in life
      expectancy.")
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
      geom_point(aes(y = life_expectancy), colour = "red") + 
      geom_point(aes(y = avg), colour = "grey") + 
      labs(
        title = paste("Avg Overall Life Expectancy vs", paste(input$country1, "Life Expectancy"))
      )
  })
  
  output$plot2 <- renderPlot({
    country_frame <- avg_life %>%
      filter(country == input$country2)
    ggplot(country_frame, aes(year)) +                    
      geom_point(aes(y = life_expectancy), colour = "blue") + 
      geom_point(aes(y = avg), colour = "grey") +
      labs(
        title = paste("Avg Overall Life Expectancy vs", paste(input$country2, "Life Expectancy"))
      )
  })
  
}

# Run the application 
shinyApp(ui = my_ui, server = my_server)
