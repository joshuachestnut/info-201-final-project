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

life_infant_comparison <- merge(fertility_data_one, fertility_data_two) %>%
  select(Entity, Year, fertility_rate, infant_mortality_rate_per_1000)

year_range_fertility <- range(fertility_data_complete$Year)
year_range_infant <- range(life_infant_comparison$Year)

my_ui <- fluidPage(
  navbarPage("Fertility Rates",
    tabPanel(
      h5("Introduction"),
  
      p("To simply say that the average fertility rate has declined over time would be a gross understatement, 
        as the average rate has fallen by more than fifty percent in the last sixty years (Roser). 
        The decline of fertility rates across the world remains of particular interest to scientists, 
        economists, and policymakers since it is a multifaceted subject that seems to possess strong 
        correlational ties to both social and economic development. This decline in the average fertility 
        rate of 4.7 children per woman to 2.5 children per woman “is one of the most fundamental social 
        changes that happened in human history. It is therefore especially surprising how very rapidly this 
        transition can indeed happen” (Roser). In addition to this decline, in terms of birth rates, 
        there has been a strong convergence between developed and less developed countries. To examine this 
        idea further, countries that “already had low fertility rates in the 1950s only slightly decreased 
        fertility rates further, while many of the countries that had the highest fertility back then saw a 
        rapid reduction of the number of children per woman” (Roser). The negative correlation between 
        women’s education and fertility is strongly observed across regions and time; however, its 
        interpretation is unclear. Women’s education level could affect fertility through its impact on 
        women’s health and their physical capacity to give birth, children’s health, the number of 
        children desired, and women’s ability to control birth and knowledge of different birth control 
        methods. Each of these mechanisms depends on the individual, institutional, and country circumstances 
        experienced. Their relative importance may change along a country’s economic development process.
        Now that the foundation of this occurrence has been formulated, the question becomes: 
        what components have contributed to this rapid change? As previously mentioned, this is the 
        result of a multitude of different contributing variables. On the surface, it can be acknowledged 
        that these declines can be attributed to the empowerment of women, increase in health and well-being 
        of children, technological and economic advancement, growth in access to efficient and quality healthcare,
        and societal development; however, it is essential that we dive deeper into these ideas. With all things 
        considered, it is understandable how economists view childbearing as an economic decision, 
        where households have to decide between “consuming” children and goods. As we have developed as a 
        world, it is evident that the impact of the this “decision” has spurred a negative correlation 
        between income and fertility–naively hinting at this idea that children are inferior goods."),
        
       h4("Section 1: Life Expectancy"),
        p("Vast improvements to Public Health such improvement in sanitation, housing, infectious disease control, 
          and education played a significant role in increasing life expectancy over the course of several years.
          Industrialized countries in the early 19th century, were first to experience increase in life expectancy
          while it remained relatively low in the rest of the world[1]. This moment in time reflects the trends 
          we see in our world today. While Public Health advancements contributed to extending life and improving
          health, these advancements were not distributed globally. While high-income countries have reached a 
          plateau in life expectancy rates, low-income countries have are steadily catching up as access to care 
          expands."),
        
        
        h4("Section 2:  GDP and Fertility Rate"),
        p("Over the course of human history, we witness strong association among the development of 
          economy and growth or decline of the population. While wealthy countries tend to have less children, 
          and poor countries more children, the relationship between fertility rates and the economy remains 
          dynamic throughout different stages of history."),
        
        h4("Section 3: Advanced Education, Labor Force Participation"),
        p("There is an interesting link among female education and childbearing. Over the years, 
          women with high educational attainment tend to have fewer children while the opposite is true 
          for those with less to no education. The economic theory of fertility suggests that financial 
          incentives affect reproductive behaviors[2]. Women who are empowered through education tend have 
          children later in life, have higher labor force participation and increased opportunity costs. 
          These women have increased bargaining rights within a household, increased access to family planning 
          methods. Dynamic consideration of these different factors is crucial in order to understand association
          among these variables."),
        
        
        h4("Section 4: Fertility Rate and Infant Mortality"),
        p("Public Health programs combined with specialized maternal and child  initiatives contributed 
          to reductions of infant and child mortality rates in developed nations while rates remain high in 
          developing nation. Infant mortality is defined as the number of children dying before the age of 5 
          and the reduction of child mortality is associated with reduction of fertility. In fact, the child 
          survival hypothesis suggests that when child mortality is reduced, then eventually fertility reduction 
          follows with the net effect of lower growth of population[3]. This demographic transition has varied 
          over time but was most prominent in the nineteenth century."),
        
        p("Works Cited: 
        “200 Years of Public Health Has Doubled Our Life Expectancy.” San Juan Basin Public Health, 20 Mar. 2018, sjbpublichealth.org/200-years-public-health-doubled-life-expectancy/.
        Cohen, et al. “Do Financial Incentives Affect Fertility?” NBER, 28 Dec. 2007, www.nber.org/papers/w13700.
        National Research Council (US) Committee on Population. “The Relationshp Between Infant and Child 
        Mortality and Fertility: Some Historical and Contemporary Evidence for the United States.” 
        From Death to Birth : Mortality Decline and Reproductive Change., U.S. National Library of Medicine, 
        1 Jan. 1998, www.ncbi.nlm.nih.gov/books/NBK233807/.")
    ),
    tabPanel(
      h5("GDP & Fertility"),
      
      # Add a sidebarLayout
      sidebarLayout(
        
        # Add a sidebarPanel within the sidebarLayout
        sidebarPanel(
          sliderInput("Year", "Select Years of Interest:", min = year_range_fertility[1], max = year_range_fertility[2], value = year_range_fertility),
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
      h5("Life Expectancy"),
      
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
    # Kimmy UI
    tabPanel(
      h5("2015 Rates for Cambodia and the United States"), # create title panel
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
    ),
    tabPanel(
      # Feven
      h5("Fertility Rate and Infant Mortality"),
      
      # Add a sidebarLayout
      sidebarLayout(
        
        # Add a sidebarPanel within the sidebarLayout
        sidebarPanel(
          sliderInput("Year", "Select Years of Interest:", min = year_range_infant[1], max = year_range_infant[2], value = year_range_infant),
          # This is a selectInput to select the country of interest.
          selectInput("Country", "Select Country of Interest", choices = life_infant_comparison$Entity, selected = "", selectize = TRUE)
        ),
        # Add the mainPanel to the fluid page.
        mainPanel(
          # In order to create tabs on the fluid page, add the tabsetPanel
          tabsetPanel(
            # This is the tabPanel for the data table.
            tabPanel("Data Table", tableOutput("dataTable2"), textOutput("tableText2")),
            # This is the tabPanel for the Correlation Plot.
            tabPanel("Correlation Plot", plotOutput("correlationPlot2"), textOutput("plotText2"))
          )
        )
      )
    )
  )
)




