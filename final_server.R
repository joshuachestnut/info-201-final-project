# load packages
library("ggplot2") # load ggplot2
library("dplyr") # load dplyr
library("rjson") # load rjson
library("jsonlite") # load jsonlite
library("tidyr") # load tidyr
library("shiny") # load shiny

#load csv files
fertility_one <- read.csv("data/fertility_data_one.csv", stringsAsFactors = FALSE) #load csv
fertility_two <- read.csv("data/fertility_data_two.csv", stringsAsFactors = FALSE) #load csv


#Question 1: 
#a) What were the female labor force participation (of women 15 years and older), advanced education and fertility rates of women in Cambodia in 2015? Round to the nearest percentage.
Cambodia_labor_force_2015 <- fertility_one %>% # use data frame fertility_one
  filter(Entity== "Cambodia") %>% #filter for entity equal to Cambodia
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(labor_force_participation_female_15_plus) #select the labor force participation rate
print(paste0(round(Cambodia_labor_force_2015), "%")) #round value and add percentage sign

Cambodia_advanced_education_2015 <- fertility_two %>% #use data frame fertility_two
  filter(Entity== "Cambodia") %>% #filter for entity equal to Cambodia
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(female_labor_force_advanced_edu) #select the labor force advanced education rate
print(paste0(round(Cambodia_advanced_education_2015), "%")) #round value and add percentage sign

Cambodia_fertility_2015 <- fertility_one %>% #use data frame fertility_one
  filter(Entity== "Cambodia") %>% #filter for entity equal to Cambodia
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(fertility_rate) #select the fertility rate
print(paste0(round(Cambodia_fertility_2015), "%")) #round value and add percentage sign

#b) How does it compare to the female labor force participation, secondary education and fertility rates of women in the United States in 2015?
US_labor_force_2015 <- fertility_one %>% #use data frame fertility_one
  filter(Entity== "United States") %>% #filter for entity equal to United States
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(labor_force_participation_female_15_plus) #select the labor force participation rate
print(paste0(round(US_labor_force_2015), "%")) #round value and add percentage sign

US_advanced_education_2015 <- fertility_two %>% #use data frame fertility_two
  filter(Entity== "United States") %>% #filter for entity equal to United States
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(female_labor_force_advanced_edu) #select the labor force advanced education rate
print(paste0(round(US_advanced_education_2015), "%")) #round value and add percentage sign

US_fertility_2015 <- fertility_one %>% #use data frame fertility_one
  filter(Entity== "United States") %>% #filter for entity equal to United States
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(fertility_rate) #select the fertility rate
print(paste0(round(US_fertility_2015), "%")) #round value and add percentage sign

All_us <- data.frame(US_labor_force_2015, US_advanced_education_2015, US_fertility_2015) #create data frame of the three above U.S. values

All_cambodia <- data.frame(Cambodia_labor_force_2015, Cambodia_advanced_education_2015, Cambodia_fertility_2015) #create data frame for the three above Cambodia values

both_countries <- full_join(All_us, All_cambodia) #join dataframes
country_names <- data.frame("U.S.", "Cambodia") %>%
  gather() %>%
  select(value)
final_df <- mutate(both_countries, Country = c("U.S.", "Cambodia"))
final_two_df <- gather(final_df, key = rate_type , value = Rate, - Country) #reshape data frame by using gather function
  
  
final_server <- shinyServer(function(input, output) { # create server function with year as input
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
"This data set contains data on the labor force participation, secondary education, fertility rates of women across a multitude of countries. We can see that different countries have different rates. By narrowing in on two countries, we can compare and observe their annual rates and see if the aforementioned relationship among education, workforce participation and fertility is valid."})
 
}) #end of my server bracket

# Reference:
#Joost de Laat & Almudena Sevilla-Sanz (2011) The Fertility and Women's Labor Force Participation puzzle in OECD Countries: The Role of Men's Home Production, Feminist Economics, 17:2, 87-119, DOI: 10.1080/13545701.2011.573484