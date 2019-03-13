library("dplyr")
library("ggplot2")
library("shiny")
library("rsconnect")

fertility_data_one <- read.csv("data/fertility_data_one.csv", stringsAsFactors = FALSE)
fertility_data_two <- read.csv("data/fertility_data_two.csv", stringsAsFactors = FALSE)

life_infant_comparison <- merge(fertility_data_one, fertility_data_two) %>%
  select(Entity, Year, fertility_rate, infant_mortality_rate_per_1000)

year_range_infant <- range(life_infant_comparison$Year)

my_ui <- fluidPage(

  # Give the UI a Title
  titlePanel("Correlation Between Fertility Rate and Infant Mortality"),

  # Add a sidebarLayout
  sidebarLayout(

    # Add a sidebarPanel within the sidebarLayout
    sidebarPanel(
      sliderInput("Year", "Select Years of Interest:", min = year_range_infant_infant[1], max = year_range_infant[2], value = year_range_infant),
      # This is a selectInput to select the country of interest.
      selectInput("Country", "Select Country of Interest", choices = life_infant_comparison$Entity, selected = "", selectize = TRUE)
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


my_server <- shinyServer(function(input, output) {
  # This outputs the data table according the the necessary selections and filters.
  output$dataTable2 <- renderTable({
    life_infant_comparison %>% filter(Year > input$Year[1] & Year < input$Year[2]) %>% filter(Entity == input$Country)
  })
  # This is the correlation plot that corresponds the the given selections and filters of the data table.
  output$correlationPlot2 <- renderPlot({
    filtered_years <- life_infant_comparison %>%
      filter(Year > input$Year[1] & Year < input$Year[2]) %>%
      filter(Entity == input$Country)
    
    new_df <- filtered_years %>% 
      gather(key = "Attributes", value = "value", fertility_rate, infant_mortality_rate_per_1000)
     comparison_plot <- ggplot(data = new_df) +
      geom_smooth(mapping = aes_string(y = "value", x = "Year", color = "Attributes")) + 
      labs(
        title = paste("Graph"),
        x = "Year",
        y = "Value"
      )
  
    comparison_plot
  })
})

shinyApp(my_ui, my_server)
