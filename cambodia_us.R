fertility_one <- read.csv("data/fertility_data_one.csv", fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE) #load csv
fertility_two <- read.csv("data/fertility_data_two.csv", fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)

Cambodia_labor_force_2015 <- fertility_one %>% # use data frame fertility_one
  filter(Entity== "Cambodia") %>% #filter for entity equal to Cambodia
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(labor_force_participation_female_15_plus) #select the labor force participation rate

Cambodia_advanced_education_2015 <- fertility_two %>% #use data frame fertility_two
  filter(Entity== "Cambodia") %>% #filter for entity equal to Cambodia
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(female_labor_force_advanced_edu) #select the labor force advanced education rate

Cambodia_fertility_2015 <- fertility_one %>% #use data frame fertility_one
  filter(Entity== "Cambodia") %>% #filter for entity equal to Cambodia
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(fertility_rate) #select the fertility rate

US_labor_force_2015 <- fertility_one %>% #use data frame fertility_one
  filter(Entity== "United States") %>% #filter for entity equal to United States
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(labor_force_participation_female_15_plus) #select the labor force participation rate

US_advanced_education_2015 <- fertility_two %>% #use data frame fertility_two
  filter(Entity== "United States") %>% #filter for entity equal to United States
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(female_labor_force_advanced_edu) #select the labor force advanced education rate

US_fertility_2015 <- fertility_one %>% #use data frame fertility_one
  filter(Entity== "United States") %>% #filter for entity equal to United States
  filter(Year == "2015") %>% #filter for year equal to 2015
  select(fertility_rate) #select the fertility rate

All_us <- data.frame(US_labor_force_2015, US_advanced_education_2015, US_fertility_2015) #create data frame of the three above U.S. values

All_cambodia <- data.frame(Cambodia_labor_force_2015, Cambodia_advanced_education_2015, Cambodia_fertility_2015) #create data frame for the three above Cambodia values

both_countries <- full_join(All_us, All_cambodia) #join dataframes
country_names <- data.frame("U.S.", "Cambodia") %>%
  gather() %>%
  select(value)
final_df <- mutate(both_countries, Country = c("U.S.", "Cambodia"))
final_two_df <- gather(final_df, key = rate_type , value = Rate, - Country)
