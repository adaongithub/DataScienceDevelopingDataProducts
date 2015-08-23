# ui.R
# Developing Data Products Course Project - Shiny App
# 2015-0-22


## print( "Entering ui.R" )

mtcars_choices <- names( mtcars )

mtcars_labels  <- 
data.frame(
  row.names = mtcars_choices, 
  c( "Miles/(US) gallon",
     "Number of cylinders",
     "Engine Displacement (cu.in.)",
     "Gross horsepower",
     "Rear axle ratio",
     "Weight (lb/1000)",
     "Quarter Mile Time (seconds)",
     "Engine Configuration (0 = Vee, 1 = Straight)",
     "Transmission (0 = Automatic, 1 = Manual)",
     "Number of forward gears",
     "Number of carburetors"
   )
)

image_scale           <- 3
regression_line_color <- "color:red"
outcome_color         <- "color:blue"
predictors_color      <- "color:green"


shinyUI(

fluidPage(
  ## print( "Beginning fluidPage()" ),
  titlePanel("Exploring Linear Models for the Motor Trend Magazine Car Data Set"),
  
  sidebarLayout(

    sidebarPanel(
      h3("Choose Outcome & Predictor(s)"),
      img( src = "Motor_Trend_Magazine-1974-October.jpg",
           height = (609/image_scale), width = (455/image_scale)
         ),
      br(),

      helpText( "Operating Instructions:
 After the initial model is plotted, please check the boxes below to select one outcome variable and one or more predictor variables.  Then press the Submit button and you'll see the adjusted R-squared value for a model using the variables you selected.  If there is only one predictor variable then a scatter plot will be generated with an optional regression line in red.  You can generate as many models as you'd like."
      ),
      
      div(
        checkboxInput(
          inputId  = "include_regression_line", 
          label    = "Include a linear regression line?",
          value    = TRUE
        ),   
        style = regression_line_color
      ),

      div(
        radioButtons(
          inputId  = "MTCARS_var_outcome", 
          label    = "MTCARS Variables - outcome",
          choices  = mtcars_choices,
          selected = mtcars_choices[1]
        ),   
        style = outcome_color
      ),

      div(
        checkboxGroupInput(
          inputId  = "MTCARS_vars_predictors", 
          label    = "MTCARS Variables - predictor(s)",
          choices  = mtcars_choices,
          selected = mtcars_choices[6]
        ),   
        style = predictors_color
      ),

      submitButton('Submit')

    ),
    
    mainPanel(
      h3( "Overview:" ),
      p(
"This Shiny application was developed in order to explore linear models and support exploratory data analysis of the 1974 Motor Trend Magazine Car Data Set.  First, the app generates a cross-correlation of each variable in the mtcars data set vs. every other variable.  This is displayed in the matrix of 11 by 11 color-coded plots immediately below.  The colors indicate the degree of correlation between variables and can serve as a guide for exploration.  Then the app generates an initial model using weight (wt) as the predictor variable and miles per gallon (mpg) as the outcome.  The app calculates the adjusted R-squared value of the model to indicate the proportion of variability in mpg that can be explained using weight as the predictor variable.  The app then plots weight vs. mpg.  After you\'ve examined the initial data model, you can select different predictors and outcomes to see which combinations produce the highest adjusted R-squared value, indicating how well those predictors explain the variability of the chosen outcome."
      ),

      h3("Results of Analysis"),
      plotOutput( outputId = "main_plot" ),
      div(
         h4( "Outcome Variable:" ),
         textOutput("text_outcome"),
         style = outcome_color
      ),

      div(
         h4( "Predictor Variable(s):" ),
         textOutput("text_predictors"),
         style = predictors_color
      ),

      h4( "Adjusted R Squared of fitted model:" ),
      textOutput("text_adj_r_squared"),

      h4( textOutput("text_plot_heading") ),

      plotOutput( outputId = "sub_plot" )
      
    )
  )
  ## print( "Ending fluidPage()" )
)

)

## print( "Exiting ui.R" )

