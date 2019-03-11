source("ui.R")

my_server <- shinyServer(function(input, output) {
  # This outputs the data table according the the necessary selections and filters.
  output$dataTable <- renderTable({
    fertility_data_complete %>% filter(Year > input$Year[1] & Year < input$Year[2]) %>% filter(Entity == input$Country)
  })
  # This is the correlation plot that corresponds the the given selections and filters of the data table.
  output$correlationPlot <- renderPlot({
    filtered_years <- fertility_data_complete %>%
      filter(Year > input$Year[1] & Year < input$Year[2]) %>%
      filter(Entity == input$Country)
    fertility_gdp_plot <- ggplot(data = filtered_years) +
      geom_point(mapping = aes_string(y = "fertility_rate", x = "gdp_per_capita")) +
      geom_smooth(mapping = aes_string(y = "fertility_rate", x = "gdp_per_capita")) +
      labs(
        title = paste("Correlation between Fertility Rate and GDP Per Capita"),
        x = "GDP per Capita",
        y = "Fertility Rate"
      )
    # In order to produce the plot, need to call it at the end of the function.
    fertility_gdp_plot
  })
})