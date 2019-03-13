# Load the dplyer package
library("dplyr")
library("tidyr")
library("plotly")
library("ggplot2")

# Read in the first data set about fertility rates. This data frame includes country, year, gdp per capita, fertility rates, life expectancy, births attended by doctors, and modern contraceptive methods.
fertility_data_set_one <- read.csv("data/fertility_data_one.csv", fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)

# Read in the second data set about fertility rates. This data frame includes country, year, gdp per capita, fertility rates, life expectancy, births attended by doctors, and modern contraceptive methods.
fertility_data_set_two <- read.csv("data/fertility_data_two.csv", fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)

#BIG QUESTION: "Were the infant mortality and fertility rates higher for Rwanda or the United States in 1960? What about in 2017?"
  #compare infant mortality and fertility rates of two countires from 1960 to 2017

#Select the columns you need from dataset 1
set_one <- fertility_data_set_one %>% 
  select(Entity, Year, fertility_rate)


#select the colums you need from dataset 2
set_two <- fertility_data_set_two %>% 
  select(Entity, Year, infant_mortality_rate_per_1000)

#join sets 
comparison_data <- merge(set_one, set_two, all = TRUE) 

  
#set up the UI 
my_ui <- fluidPage(
  titlePanel("Life Expectancy and Infant Mortality Over Years"),
  sidebarLayout(
    sidebarPanel(
      selectInput("incountry", "Select a Country", choices = comparison_data$Entity,
                  selected = comparison_data$Entity),
      sliderInput("yearslide", "Select a range of years",
                  min = 1960,
                  max = 2016,
                  value= 2016)
    ),
    
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("Table", tableOutput("Table")),
        tabPanel("Plot", plotOutput("plot"))
      )
    )
  )
)


#set up server 
my_server <- function(input, output) {
  
  output$Table <- renderTable({
    
    filtered_years <- comparison_data %>% 
      filter(Year < input$yearslide) %>% 
      
      filter(Entity == input$incountry)
    
    filtered_years })
  
  output$plot <- renderPlot({
    
    p <- ggplot(data = gathered_data) +
      geom_point(mapping = aes(x = yearslide, y = Value))
    
    plotOutput(outputId = "plot")
  })
  
  output$sentencevar <- renderText({
    paste0("This is a table that shows the different values of the forested percentage for", 
           input$incountry, "between the years", input$yearslide) 
  })
}

shinyApp(ui = my_ui, server = my_server)
  












            
