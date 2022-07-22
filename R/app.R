#' Launch app to explore JTS data
#' @export
jts_app = function() {
  if (interactive()) {
    if (!requireNamespace("shiny", quietly = TRUE)) {
      stop("shiny package needed for this function to work. Please install it.", call. = FALSE)
    }
  }
  ui = shiny::navbarPage(
    "JTS Data Visualisation App (prototype)",
    shiny::tabPanel(
      "Pick a type",
      shiny::selectInput(
        "type",
        "Which type?",
        choices = jts_params$type,
        selected = "jts04"
      ),
      shiny::textInput(
        "purpose",
        paste0("Which purpose? Options include:\n", paste(jts_params$purpose, collapse = " ")),
        value = "employment"
      ),
      shiny::textInput(
        "sheet",
        paste0("Which sheet within the JTS spreadsheet? Options include:\n", paste(c(jts_params$year, "meta"), collapse = " ")),
        value = "2019"
      )
    ),
    shiny::tabPanel(
      "Example tab",
      shiny::selectInput(
        "test",
        "Example tab",
        choices = jts_params$purpose,
        selected = 2019
      )
    ),
    shiny::mainPanel(
      shiny::titlePanel("The selected tables"),
      shiny::dataTableOutput("jts_lookup"),
      shiny::titlePanel("Search all JTS tables"),
      DT::DTOutput(outputId = "table1")
      )
  )
  server = function(input, output, session) {
    output$jts_lookup = shiny::renderDataTable(
      options = list(dom = "t"),
      lookup_jts_table(type = input$type, purpose = input$purpose)
    )
    output$table1 = DT::renderDT(
      jts_tables[1:4],
      options = list(
        search = list(
          regex = TRUE,
          caseInsensitive = FALSE,
          search = ''
        ),
        pageLength = 5
      ))
  }
  shiny::shinyApp(ui, server)
}
