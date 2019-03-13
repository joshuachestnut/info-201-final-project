final_ui <- fluidPage(

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


)#end of fluidpage