#' ss_cluster UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_ss_cluster_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidPage(
      column(
        width = 4,
        box(
          width = NULL,
          title = "Parameters",

          sliderInput(
            ns("pi100"),
            "Proportion in the intervention group (%)",
            min = 1,
            max = 100,
            value = 80,
            step = 1
          ),
          #bsTooltip("sen_spe100",title= "Estimated value of sensitivity (or specificity)", placement = "right", trigger = "hover",
          #options = NULL),

        sliderInput(
          ns("pc100"),
          "Proportion in the control group (%)",
          min = 1,
          max = 100,
          value = 50,
          step = 1
        ),

        numericInput(
          inputId = ns("alpha100"),
          label = "Alpha (%):",
          value = 5
        ),
        # bsTooltip("alpha100",title= "Defines Significance level.", placement = "right", trigger = "hover",
        #           options = NULL),

        numericInput(ns("cs"),
                     label = "Cluster size",
                     value = 100),

        numericInput(
          inputId = ns("coef_var"),
          label = "Coefficient of variation",
          value = 0.25
        ),

        radioButtons(
          inputId = ns("pairing"),
          choices = c("Paired", "Unpaired"),
          label = "Design:"
        ),
      ),
      ),


      column(
        width = 8,
        box(
          title = "The Output",
          width = 12,
          background = "light-blue",
          "The table below gives you the Power in % and the number of clusters to achieve that power. For paired designs this number indicates the number of cluster pairs. There is no example text for the protocol as this is a more complex design, and these values need to be verified in all cases."

        ),
        box(DT::dataTableOutput(ns(
          "cluster_number_table"
        )), width = 12),

        box(
          title = "Reference:",
          width = 12,
          "Hayes, R. J., & Moulton, L. H. (2017). Cluster randomised trials. Chapman and Hall/CRC.",
          background = "aqua"
        )
      )
    ),
  )
}

#' ss_cluster Server Functions
#'
#' @noRd
mod_ss_cluster_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    cluster_sample_size <- reactiveValues(table = NULL, A_value = NULL)

    observeEvent(c(input$pi100, input$pc100, input$alpha100, input$cs, input$coef_var, input$pairing), {
      pow_list <- c(0.8, 0.85, 0.9, 0.95)
      cluster_sample_size$A_value <- ifelse(input$pairing == "Paired", 2, 1)

      cluster_sample_size$table <- data.frame(check.names = FALSE)
      for(i in pow_list){
        n = cluster_random_sample_size(alpha = input$alpha100/100,
                                       power =i,
                                       coef_var = input$coef_var,
                                       A = cluster_sample_size$A_value,
                                       pi = input$pi100/100,
                                       pc = input$pc100/100,
                                       CS = input$cs)
        it_df <- data.frame(`Power (%)` = i*100, `N Clusters` = n, check.names = FALSE)

        cluster_sample_size$table <- rbind(cluster_sample_size$table, it_df)

      }

          })
    output$cluster_number_table <- DT::renderDataTable({
      DT::datatable(cluster_sample_size$table,
                extensions = 'Buttons',
                options = list(dom = 'Blfrtip',
                               buttons = list(
                                 list(extend = 'copy', filename = "n_clusters"),
                                 list(extend = 'csv', filename = "n_clusters"),
                                 list(extend = 'excel', filename = "n_clusters"),
                                 list(extend = 'pdf', filename = "n_clusters")),
                               lengthMenu = list(c(10,-1),
                                                 c(10,"All"))))
    })


  })
}

## To be copied in the UI
# mod_ss_cluster_ui("ss_cluster_1")

## To be copied in the server
# mod_ss_cluster_server("ss_cluster_1")
