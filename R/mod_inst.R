#' inst UI Function
#'
#' @description Instructions Page.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import shinydashboard
#' @import shinyWidgets
#'
#'


mod_inst_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidPage(
   column(width = 6, box(
      title = "Sample Size Calculation for Performance Evaluation Studies",
      width = 12,
      "The aim of this application is to facilitate sample size calculations for performance evaluation studies for diagnostic tests.
            Please, calculate the sample size separately for sensitivity and specificity.
            Because the sensitivity is usually the limiting factor, the default mode calculates the sample sizes for sensitivity.
            You can switch to specificity calculations by ticking the dedicated box.
            This application is optimised for simple study designs. If you have more complex designs, please contact Berra.",
      background = "olive"
    ),

    box(
      title = "Performance Estimate",
      width = 12,
      "Please enter the predicted sensitivity (or specificity) to be tested.",
      background = "maroon"
    ),

    box(
      title = "Full width of confidence interval",
      width = 12,
      "The full width of the confidence interval (CI) tells you how many percentage points your results will differ from the real population value.
            For example, A 60% “yes” response with a CI 10% = between 55% and 65% of people think the answer is yes.
            If the sample sizes are too high with the default value of the CI, you can increase it upto 30%.
            However, please note that higher error margin means lower precision.",
      background = "orange"
    ),

    box(
      title = "Alpha",
      width = 12,
      background = "black",
      "Alpha determines the significance level.
        It defines the acceptable probability that an event could have occurred by chance.
        When alpha is set to 5%, we say the event is significant when p-value < 0.05. Do NOT change this value unless you know what you are doing."
    ),

    box(
      title = "Prevalence",
      width = 12,
      "This is the estimated prevalence of the diease that you are working on in your population. If this is a retrospective study, please put the prevalence to 100%",
      background = "teal"
    ),
    box(
      title = "Prevalence Power",
      width = 12,
      background = "black",
      "The estimated prevalence is associated to the 'prevalence power' (an advanced parameter), which represents the probability to truly detect your given disease prevalence.
            Prevalence and its associated power are important in prospective studies, where a portion of the population will NOT have the disease.
            If you do not have a reason, do NOT change the default value."
    )
  ),


  column(width = 6, box(
    title = "Sample Size Calculation for Cluster Randomized Trials",
    width = 12,
    "The aim of this application is to facilitate sample size calculations for cluster randomized trials.You can calculate the sample size for paired and unpaired designs separately, using the dedicated radio buttons for design. Please note that all the sample size obtained by this app needs to be verified by Berra or another statistician before submitting the protocol to the ethics comity",
    background = "olive"
  ),

  box(
    title = "Proportion in the intervention group",
    width = 12,
    "Please enter the expected  outcome occurence (%) in the intervention group.",
    background = "light-blue"
  ),

  box(
    title = "Proportion in the control group",
    width = 12,
    "Please enter the expected  outcome occurence (%) in the control group.",
    background = "light-blue"
  ),

  box(
    title = "Alpha",
    width = 12,
    background = "black",
    "Alpha determines the significance level.
        It defines the acceptable probability that an event could have occurred by chance.
        When alpha is set to 5%, we say the event is significant when p-value < 0.05. Do NOT change this value unless you know what you are doing."
  ),

  box(
    title = "Cluster size",
    width = 12,
    "This is the estimated number of people in a single cluster. Please enter an estimate based on the minimum number that you expect to be more conservative.",
    background = "black"
  ),
  box(
    title = "Coefficient of variation",
    width = 12,
    background = "black",
    "This value is necessary to take into account the variation in the outcome occurence between different clusters of the same group. As a rough guideline, experience from field studeis suggest that this value is generally ≤0.25, and rarely exceeds 0.5.  "
  )
  )
  )

  )


}

#' inst Server Functions
#'
#' @noRd
mod_inst_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_inst_ui("inst_1")

## To be copied in the server
# mod_inst_server("inst_1")
