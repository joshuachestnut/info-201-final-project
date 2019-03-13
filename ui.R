library("dplyr")
library("ggplot2")
library("shiny")
library("rsconnect")
library("tidyr") # load tidyr

fertility_data_one <- read.csv("data/fertility_data_one.csv", fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)
fertility_data_two <- read.csv("data/fertility_data_two.csv", fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)
data <- read.csv("data/fertility_data_two.csv", fileEncoding = "UTF-8-BOM", stringsAsFactors = FALSE)
countries <- as.character(data[[1]])

fertility_data_complete <- merge(fertility_data_one, fertility_data_two) %>%
  select(Entity, Year, fertility_rate, gdp_per_capita)

year_range <- range(fertility_data_complete$Year)

my_ui <- fluidPage(
  navbarPage("Fertility Rates",
    tabPanel(
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
    ),
    tabPanel(
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
    ),
    tabPanel(
      titlePanel("2015 Rates for Cambodia and the United States"), # create title panel
      h5("What were the female labor force participation (of women 15 years and older), advanced education and fertility rates of women in Cambodia in 2015?
         How does it compare to the female labor force participation, secondary education and fertility rates of women in the United States in 2015?"),
      h5("Select Rate Type"), # create header
      sidebarLayout( # create sidebar Layout
        
        sidebarPanel( #create sidebar panel
          selectInput(
            inputId = "Category", # select input and set inputId
            label = "Rate Type", # create label
            choices =  c("Female Labor Force Participation (15+)" = "labor_force_participation_female_15_plus", "Advanced Education" = "female_labor_force_advanced_edu", "Fertility" = "fertility_rate"), # create choice strings
            selected = "Female Labor Force Participation (15+)" # select initial value
          )#, # end of selectInput
          
          #checkboxGroupInput("country_name", "Variables to show:", c("Cambodia", "United States" = "U.S.") # create choice strings
          #) # end of checkboxGroupInput
          
        ), #end of sidebarpanel
        
        mainPanel( # show a plot of generated distribution
          tabsetPanel(
            tabPanel("Visual",
                     plotOutput("bargraph"), # define graph output
                     tableOutput("newtable"), #output table
                     textOutput("bardescription") # output sentence
            ), #end of tabPanel
            tabPanel("Information",
                     h4("Why this question is relevant"),
                     textOutput("overalldescription"),
                     h4("How this data supports it"),
                     textOutput("descriptionpart2")
            ) #end of tabPanel
          ) # end of tabsetPanel
        )# end of main Panel
        
      ) # end of sidebar layout
    )
  )
)




