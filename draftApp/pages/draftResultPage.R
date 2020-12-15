fluidPage(
  fluidRow(
    HTML("<h1>The Draft has Ended</h1>")
  ),
  br(),
  fluidRow(
    tableOutput('display_result_table')
  ),
  fluidRow(
    downloadButton('download_result_table')
  )
)