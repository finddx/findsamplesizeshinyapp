#' ss_simple UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_ss_simple_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      column(
        width = 4,
        box(width=NULL, title = "Parameters",
            sliderInput(ns("sen_spe100"),
                        "Performance Estimate: Sensitivity/Specificity (%)",
                        min = 1,
                        max = 100,
                        value = 80,
                        step = 1),

            bsTooltip("sen_spe100",title= "Estimated value of sensitivity (or specificity)", placement = "right", trigger = "hover",
                      options = NULL),

            checkboxInput(ns("spe"), "Please check if making the calculations for SPECIFICITY", value = FALSE),

            sliderInput(ns("margin200"),
                        "Error Margin -  width of the confidence interval (%)",
                        min = 1,
                        max = 30,
                        value = 5,
                        step = 0.5),
            numericInput(inputId = ns("alpha100"), label = "Alpha (%):", value = 5),
            # bsTooltip("alpha100",title= "Defines Significance level.", placement = "right", trigger = "hover",
            #           options = NULL),

            sliderInput(ns("prevalence100"),
                        "Prevalence (%)",
                        min = 1,
                        max = 100,
                        value = 20,
                        step = 1),

            numericInput(inputId = ns("prevpower100"), label = "Prevalence Power (%):", value = 80)
        )
      ),
      column(width = 8,
             box(title = "The Output", width = 12, background = "light-blue", "The table below gives you the Power in %. Power represents the probability of making a correct decision.
               'n confirmed cases', is the number of positives (for sensitivity, negatives for specificity) by the reference that you need to detect.
                  'n to screen' is relevant for prospective studies and indicates the total number of participants to screen in order to obtain the 'n confirmed cases'." ),
             box(DT::dataTableOutput(ns("sample_size_table")), width = 12),
             box(title = "Example text for the protocol", width = 12, "The sensitivity and the specificity of the [DISEASE] RDTs are expected to be [sensitivity]% and [specificity]% respectively.
                  Based on these values, [n confirmed cases] confirmed positive and [n confirmed cases] confirmed negative cases are needed to reach a power of [Power]%, with a significance level of 95% and a margin of error of [Error Margin]%.
                  Based on existing data, the prevalence of [DISEASE] was estimated to be [Prevalence]%. With a prevalence power of 80% (i.e. power to detect the desired number of cases), we would need to screen a total of [n to screen] participants (Zhou et al. 2011)."),
             box(title = "Reference:", width = 12, "Zhou XH, Obuchowski NA and McClish DK. Statistical Methods in Diagnostic Medicine. 2011;2:193-228", background = "aqua")
      )
    )

  )
}

#' ss_simple Server Functions
#'
#' @noRd
mod_ss_simple_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    simple_sample_size <- reactiveValues(dt = NULL, spe = NULL)

      observeEvent(c(input$spe, input$sen_spe100, input$alpha100, input$margin200, input$prevalence100, input$prevpower100), {
        simple_sample_size$spe <- input$spe
      perform_char <- ifelse(simple_sample_size$spe == TRUE, "spe", "sen")

      addTooltip(session, "alpha100", "Do NOT change unless you know what you are doing.", placement = "top",
                 trigger = "hover", options = NULL)

      addTooltip(session, "margin200", "Ex. A 60% “yes” response with an error margin 10% = between 55% and 65% of people think the answer is yes.", placement = "bottom",
                 trigger = "hover", options = NULL)

      addTooltip(session, "prevalence100", "The estimated disease prevalence. RETOSPECTIVE = 100%", placement = "right",
                 trigger = "hover", options = NULL)

      addTooltip(session, "prevpower100", "Do NOT change unless you know what you are doing.", placement = "top",
                 trigger = "hover", options = NULL)

      pow_list <- c(0.8, 0.85, 0.9, 0.95)
      simple_sample_size$dt <- gen_pow_curve(seq = pow_list,
                          sen_spe = input$sen_spe100/100,
                          alpha = input$alpha100/100,
                          margin = input$margin200/200,
                          prevalence = input$prevalence100/100,
                          prevalence_power = input$prevpower100/100 ,
                          performance_characteristic = perform_char)
      })


      output$sample_size_table <- DT::renderDataTable({
        DT::datatable(simple_sample_size$dt,
                  extensions = 'Buttons',
                  options = list(dom = 'Blfrtip',
                                 buttons = list(
                                   list(extend = 'copy', filename = "SampleSize"),
                                   list(extend = 'csv', filename = "SampleSize"),
                                   list(extend = 'excel', filename = "SampleSize"),
                                   list(extend = 'pdf', filename = "SampleSize")),
                                 lengthMenu = list(c(10,-1),
                                                   c(10,"All"))))
      })







  })
}

## To be copied in the UI
# mod_ss_simple_ui("ss_simple_1")

## To be copied in the server
# mod_ss_simple_server("ss_simple_1")
