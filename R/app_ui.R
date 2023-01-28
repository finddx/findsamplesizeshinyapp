#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @import shinyWidgets
#' @import shinyBS

#' @noRd

findtitle <- tags$div(
  tags$img(src="https://www.finddx.org/wp-content/themes/find/img/logo_header.svg",
           height = '50', width='100'),
  tags$p("Sample Size Calculations")
)

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    dashboardPage(skin = "black",
                  dashboardHeader(title = findtitle),
                 dashboardSidebar(
                   sidebarMenu(
                     menuItem("User Instructions", tabName = "instructions"),
                     menuItem("Basic Performance Evaluations", tabName = "sample_size"),
                     menuItem("Custer Randomized Trials", tabName = "sample_size_cluster_random")
                   )
                 ),

                 dashboardBody(
                   setSliderColor(c("Deeppink ", "Orange", "Teal", "Chartreuse3", "Firebrick3"),
                                  c(1,2,3,4,5)),

                   tabItems(
                     tabItem(tabName = "instructions",
                             mod_inst_ui("inst_1")),
                     tabItem(tabName = "sample_size",
                               mod_ss_simple_ui("ss_simple_1")),
                     tabItem(tabName = "sample_size_cluster_random",
                             mod_ss_cluster_ui("ss_cluster_1")
                     )
                   )
                 )

                 )

  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "findsamplesizeshinyapp"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
