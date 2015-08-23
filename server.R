# server.R
# Developing Data Products Course Project - Shiny App
# 2015-08-22


fit_lm_to_preds <- function( outcome_var, predictor_vars, a_df ) 
{
  if ( length(predictor_vars) == 0) 
  { predictor_vars <- c(".")
  }
  preds_str     <- paste( predictor_vars, collapse=" + " )
  model_str     <- paste0(outcome_var, " ~ ", preds_str)
  ## print( paste0( "model_str = \"", model_str, "\"" ) )
  model_formula <- as.formula( model_str )
  lmodel <- lm( formula = model_formula, data = a_df )
  ## print( summary( lmodel ) )
  lmodel
}

set.seed( 123 )  # set a particular random number seed for reproducibiity
# install.packages( "ggplot2" )  # only needed for initial installation
## library( "ggplot2" )
# install.packages( "gclus" )  # only needed for initial installation
library( "gclus" )

data( mtcars )

# Create a data frame with correlations
mtcars_cors    <- abs( cor(mtcars) )

# Create a data frame with three corresponding colors
mtcars_cor_col <- dmat.color( mtcars_cors,
                              colors=c("white", "light blue", "green") ) 
# Reorder variables with highest correlation closest to diagonal
mtcars_cors_ordered <- order.single(mtcars_cors)


shinyServer(
  
  function(input, output)
  {
  
    output$text_outcome <-renderText({
      input$MTCARS_var_outcome
    })
  
    output$text_predictors <- renderText({ 
      input$MTCARS_vars_predictors
    })

    output$text_adj_r_squared <- renderText({ 
      the_fit <<-
      fit_lm_to_preds( outcome_var    = input$MTCARS_var_outcome,
                       predictor_vars = input$MTCARS_vars_predictors,
                       a_df           = mtcars
                     ) 
      summary(the_fit)$adj.r.squared
    })


    output$main_plot <- renderPlot({

      cpairs( mtcars, mtcars_cors_ordered, panel.colors=mtcars_cor_col,
              pch=20, gap=.5,
              main="Data Set mtcars Variables Ordered by Correlation\nCorrelation: low (white), medium (blue), high (green)"
      ) 

    })

    output$sub_plot <- renderPlot({

    if ( length( input$MTCARS_vars_predictors ) == 1 )
    {
      output$text_plot_heading <-renderText({
        "Plot of the Single Predictor versus Outcome:" 
      })
  
      x_source <- input$MTCARS_vars_predictors[1]
      y_source <- input$MTCARS_var_outcome
      plot(
            x=mtcars[ , x_source ], xlab="",
            y=mtcars[ , y_source ], ylab=""
          )
      m_title <- paste0( "Plot of outcome ", y_source,
                         " versus predictor ", x_source
                       )
      if ( input$include_regression_line ) {
        m_title <- paste0( m_title,
                           "\n(the red line is the regression line for the linear model)" )
        if ( x_source != y_source )
        { abline( the_fit,  col="red", lwd=1.5)
        } else
        { abline( a=0, b=1, col="red", lwd=1.5)
        }
      }
      title( main = m_title, sub = "",
             xlab = x_source, ylab = y_source,
             line = NA, outer = FALSE )

    } else
    {
      output$text_plot_heading <-renderText({
        "" 
      })
    }
  })
  
  }
)
