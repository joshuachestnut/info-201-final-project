source("ui.R")
source("cambodia_us.R")

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
    
    avg_life <- data %>%
      filter(life_expectancy != "NA") %>%
      select(
        Year, life_expectancy, Entity, fertility_rate
      ) %>% 
      group_by(Year) %>% 
      mutate(
        avg = mean(life_expectancy)
      ) %>% 
      distinct()
    
    output$plot1 <- renderPlot({
      country_frame <- avg_life %>%
        filter(Entity == input$country1)
      
      ggplot(country_frame, aes(Year)) +                    
        geom_point(aes(y = life_expectancy), colour = "red") + 
        geom_point(aes(y = fertility_rate), colour = "grey") + 
        labs(
          title = paste("Avg Overall Life Expectancy vs Fertility Rate for", input$country1)
        )
    })
    
    output$plot2 <- renderPlot({
      country_frame <- avg_life %>%
        filter(Entity == input$country2)
      ggplot(country_frame, aes(Year)) +                    
        geom_point(aes(y = life_expectancy), colour = "blue") + 
        geom_point(aes(y = fertility_rate), colour = "grey") +
        labs(
          title = paste("Avg Overall Life Expectancy vs Fertility Rate for", input$country2)
        )
  })
    
  # Kimmy's Server
    output$bargraph <- renderPlot({ # plot the output labeled plot
      
      filtered_two_df <- final_two_df %>% # create variable filtered_years, filter for when year is equal to input year
        #filter(Country %in% input$country_name) %>% # filter for country equal to country input
        filter(rate_type %in% input$Category)
      
      bargraph1 <- ggplot(data = filtered_two_df) + # plot filtered_years data
        geom_col(mapping = aes(x= rate_type, y= Rate , fill = Country), position = position_dodge((width = 0.9))) +  # specify aesthetics
        scale_fill_brewer(palette = "Set1") + # specify color palette
        labs(title = "2015 Cambodia and U.S. Data", x= NULL, y = "Rate (%)") # create labels
      
      bargraph1 # return plot
      
    }) # end of renderplot
    
    output$newtable <- renderTable({ #create a table
      filtered_two_df <- final_two_df %>% # create variable filtered_two_df
        filter(rate_type %in% input$Category) %>% #filter for rate type equal to category
        select(Country, Rate) #select country and rate columns
      filtered_two_df #return data frame
    })
    
    output$bardescription <- renderText({ # render Text
      bar <- list()
      bar[["labor_force_participation_female_15_plus"]] <- "female labor force participation rate"
      bar[["female_labor_force_advanced_edu"]] <- "advanced education rate"
      bar[["fertility_rate"]] <- "fertility rate"
      
      message_str_bar <- paste0("Cambodia had a higher ", bar[[input$Category]], " than the United States in 2015.") # create sentence with changing year variable
      message_str_bar # return message string
    }) # end of renderText
    
    output$overalldescription <- renderText({ #render text description
      "Women who obtain higher levels of education are more likely to have lower fertility rates (Pradhan). Additionally, studies have shown that countries with lower-fertility levels also have lower female labor force participation levels (Joost). However, this rate varies across countries. By observing the trends across countries in different parts of the world, we can explore the role of education in fertility and in effect, the role of fertility on labor force participation. We can then identify the factors that might cause these relationships to occur." 
    }) 
    
    output$descriptionpart2 <- renderText({ #render text description
      "This data set contains data on the labor force participation, secondary education, 
      fertility rates of women across a multitude of countries. We can see that different 
      countries have different rates. By narrowing in on two countries, we can compare and 
      observe their annual rates and see if the aforementioned relationship among education, 
      workforce participation and fertility is valid."})
    
    # Feven's Server
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