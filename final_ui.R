new_page_one <- tabPanel("Visual",
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
    plotOutput(outputId = "bargraph"), # define graph output
    tableOutput(outputId = "newtable"), #output table
    textOutput(outputId = "bardescription") # output sentence
  ) # end of mainPanel
  
) # end of sidebar layout
  )# end of page one

new_page_two <- tabPanel("Information",
  h4("Why this question is relevant"),
  textOutput(outputId = "overalldescription"),
  h4("How this data supports it"),
  textOutput(outputId = "descriptionpart2")
)#end of page _two

final_ui <-
  navbarPage( # create navbarPage
    "2015 Data", # title navbarpage
    new_page_one, # include first page
    new_page_two # include second page
  ) # end of navbar